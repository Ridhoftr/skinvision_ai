from fastapi import FastAPI, UploadFile, File
from fastapi.staticfiles import StaticFiles
from tensorflow.keras.models import load_model
import numpy as np
from PIL import Image
from explain import generate_shap

app = FastAPI()

app.mount(
    "/shap",
    StaticFiles(directory="shap_images"),
    name="shap"
)

# Load model CNN
model = load_model("model/skin_cnn.keras")

classes = {
    0: "Actinic Keratoses",
    1: "Basal Cell Carcinoma",
    2: "Benign Keratosis",
    3: "Dermatofibroma",
    4: "Melanoma",
    5: "Melanocytic Nevi",
    6: "Vascular Lesions"
}

@app.get("/")
def home():
    return {"message": "SkinVision AI API Running"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):

    image = Image.open(file.file)

    # Pastikan RGB
    image = image.convert("RGB")

    image = image.resize((128, 128))

    image = np.array(image)

    image = image / 255.0

    image = np.expand_dims(image, axis=0)

    prediction = model.predict(image, verbose=0)
    
    generate_shap(model, image)

    index = int(np.argmax(prediction))

    disease = classes[index]

    confidence = float(np.max(prediction))

    return {
        "disease": disease,
        "confidence": round(confidence * 100, 2),
        "shap_image": "shap/shap_result.png"
    }