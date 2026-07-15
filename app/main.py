import google.generativeai as genai # Assurez-vous d'utiliser le bon import
import os
from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware 

load_dotenv()
GENAI_API_KEY = os.getenv("GENAI_API_KEY")

# Configuration correcte
genai.configure(api_key=GENAI_API_KEY)

app = FastAPI(title="Assistant Services Réseau - GenAI")

class Question(BaseModel):
    question: str
# ← AJOUTE CES LIGNES
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/chat")
def chat(question: Question):
    try:
        # 1. Initialiser le modèle
        model = genai.GenerativeModel("gemini-3-flash-preview") # gemini-3-flash si disponible dans votre région

        # 2. Utiliser generate_content au lieu de generate
        prompt = f"""
        Tu es un assistant qui répond aux questions des clients concernant les codes et services réseau en Tunisie.
        Fournis des réponses claires, courtes et précises.
        Question : {question.question}
        Réponse :
        """
        
        response = model.generate_content(prompt)

        # 3. Accéder au texte (la syntaxe est .text)
        answer = response.text.strip()

    except Exception as e:
        answer = f"Erreur : {str(e)}"

    return {"response": answer}