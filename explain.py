import shap
import numpy as np
import matplotlib.pyplot as plt
import os

def generate_shap(model, image):

    try:

        # Background sederhana
        background = np.zeros(
            (1, 128, 128, 3),
            dtype=np.float32
        )

        explainer = shap.GradientExplainer(
            model,
            background
        )

        shap_values = explainer.shap_values(
            image
        )

        os.makedirs(
            "shap_images",
            exist_ok=True
        )

        output_path = (
            "shap_images/shap_result.png"
        )

        plt.figure(figsize=(6,6))

        if isinstance(
            shap_values,
            list
        ):
            shap_map = shap_values[0][0]
        else:
            shap_map = shap_values[0]

        # Ambil gambar asli
        original = image[0]

        # Hitung heatmap SHAP
        heatmap = np.abs(shap_map).mean(axis=-1)

        # Normalisasi agar nilai berada pada rentang 0-1
        heatmap = (heatmap - heatmap.min()) / (
            heatmap.max() - heatmap.min() + 1e-8
        )

        plt.figure(figsize=(6, 6))

        # Tampilkan gambar asli
        plt.imshow(original)

        # Overlay heatmap SHAP
        plt.imshow(
            heatmap,
            cmap="jet",
            alpha=0.45,
        )

        plt.axis("off")

        plt.savefig(
            output_path,
            bbox_inches="tight",
            pad_inches=0
        )

        plt.close()

        return output_path

    except Exception as e:

        print(
            "SHAP ERROR:",
            str(e)
        )

        return None