
from fastapi import FastAPI, Request
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import json

app = FastAPI()

# 1. Load your model and labels
# Make sure the filenames here match exactly what you saved
model = tf.keras.models.load_model('wastelink_v1_model.keras')
with open('labels.json', 'r') as f:
    labels = json.load(f)

@app.post("/predict")
async def predict(request: Request):
    # This receives the raw image buffer from the backend
    body = await request.body()
    
    # Convert buffer to image
    img = Image.open(io.BytesIO(body)).convert('RGB')
    img = img.resize((180, 180)) 
    
    # Process for the model
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    
    # Get prediction
    predictions = model.predict(img_array)
    score = tf.nn.softmax(predictions[0])
    class_index = np.argmax(score)
    
    return {
        "prediction": labels[str(class_index)],
        "confidence": float(100 * np.max(score))
    }
