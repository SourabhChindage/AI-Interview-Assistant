import os
import requests
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

# ✅ Use environment variable (DO NOT hardcode keys)
OPENROUTER_API_KEY = "Use Your Own Api Key"


class InterviewRequest(BaseModel):
    subject: str
    previous_qa: list
    user_answer: str | None = None
    mode: str | None = "question"  # "question" or "feedback"


# =========================================================
# PROMPT GENERATOR
# =========================================================
def generate_prompt(subject, previous_qa, user_answer, mode="question"):

    # ================= BUILD CONVERSATION SAFELY =================
    conversation = ""

    if previous_qa:
        for idx, qa in enumerate(previous_qa, 1):
            conversation += f"Question {idx}: {qa['question']}\n"
            conversation += f"Answer {idx}: {qa['answer']}\n"

    # Add latest answer if provided (IMPORTANT FIX)
    if user_answer:
        conversation += f"Latest Candidate Answer: {user_answer}\n"

    # ================= FIRST QUESTION =================
    if not previous_qa and not user_answer and mode == "question":
        return f"""
You are a professional and realistic technical interviewer.

Subject: {subject}

Ask the FIRST interview question.
Start from basic concepts.
Keep it clear and concise.
Return only the question.
"""

    # ================= FEEDBACK MODE =================
    if mode == "feedback":
        return f"""
You are a senior technical interviewer.

Subject: {subject}

Full Interview Conversation:
{conversation}

Score the candidate based on its question understanding ability, his knowledge, and answers strength as well as confidence. Score out of 100.
And then below that Generate a professional short structured feedback report including:

1. Overall Performance Summary
2. Technical Strengths
3. Areas of Improvement
4. Communication & Clarity
5. Confidence & Problem Solving Approach
6. Final Rating (out of 10)
7. Clear Actionable Suggestions

Be honest but constructive.
Do NOT ask any more questions.
Return only the feedback report.
"""

    # ================= QUESTION MODE =================
    return f"""
You are a professional, human-like technical interviewer.

Subject: {subject}

Interview Conversation So Far:
{conversation}

Instructions:

1. FIRST evaluate the candidate's latest answer internally.
2. Start your response with:
   - Brief appreciation if correct (1 sentence)
   - OR gentle correction if partially correct
   - OR encouragement if weak

3. Then ask the NEXT logical question.
4. Do NOT repeat any previous questions.
5. Increase difficulty gradually if answers are strong.
6. If answer is weak, simplify OR shift to related subtopic.
7. Avoid generic textbook questions.
8. Maintain natural conversational tone.

If:
- Candidate says "end interview"
- Candidate says "stop"
- Candidate says "generate feedback"
- OR interview already reached around 10 meaningful questions

Return exactly:
END_INTERVIEW

Otherwise:
Return appreciation + next question.
"""



# =========================================================
# INTERVIEW ENDPOINT
# =========================================================
@router.post("/interview")
def interview(request: InterviewRequest):

    if not OPENROUTER_API_KEY:
        return {"error": "API key not configured."}

    prompt = generate_prompt(
        request.subject,
        request.previous_qa,
        request.user_answer,
        request.mode or "question"
    )

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": "openai/gpt-4o-mini",
                "messages": [
                    {"role": "user", "content": prompt}
                ],
                "temperature": 0.7  # slight randomness to reduce repetition
            },
            timeout=30
        )

        if response.status_code != 200:
            print("OpenRouter Error:", response.text)
            return {"error": "AI service error."}

        result = response.json()

        if "choices" not in result:
            print("Invalid AI response:", result)
            return {"error": "Invalid AI response."}

        ai_text = result["choices"][0]["message"]["content"].strip()

        # ================= HANDLE END =================
        if "END_INTERVIEW" in ai_text and request.mode == "question":
            return {
                "end": True
            }

        # ================= FEEDBACK RESPONSE =================
        if request.mode == "feedback":
            return {
                "feedback": ai_text
            }

        # ================= NORMAL QUESTION =================
        return {
            "next_question": ai_text
        }

    except requests.exceptions.RequestException as e:
        print("Request failed:", str(e))
        return {"error": "Network error while contacting AI service."}
