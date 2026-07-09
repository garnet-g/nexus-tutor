export const MAX_IMAGE_DIMENSION = 768;
const JPEG_QUALITY = 0.82;

/**
 * Downscales a captured photo client-side before it's sent to Gemini Vision.
 * Camera captures are often 3000px+ on the long edge; the vision model gets
 * no accuracy benefit above ~1280px for a worksheet photo, so this cuts the
 * upload size and vision-input tokens for free. Returns the original file
 * unchanged if it's already within bounds.
 */
export async function downscaleImageFile(file: File): Promise<File> {
  const bitmap = await createImageBitmap(file);
  const { width, height } = bitmap;

  if (width <= MAX_IMAGE_DIMENSION && height <= MAX_IMAGE_DIMENSION) {
    bitmap.close();
    return file;
  }

  const scale = MAX_IMAGE_DIMENSION / Math.max(width, height);
  const targetWidth = Math.round(width * scale);
  const targetHeight = Math.round(height * scale);

  const canvas = document.createElement("canvas");
  canvas.width = targetWidth;
  canvas.height = targetHeight;

  const context = canvas.getContext("2d");
  if (!context) {
    bitmap.close();
    return file;
  }

  context.drawImage(bitmap, 0, 0, targetWidth, targetHeight);
  bitmap.close();

  const blob = await new Promise<Blob | null>((resolve) => {
    canvas.toBlob(resolve, "image/jpeg", JPEG_QUALITY);
  });

  if (!blob) {
    return file;
  }

  const baseName = file.name.replace(/\.[^.]+$/, "");
  return new File([blob], `${baseName}.jpg`, { type: "image/jpeg" });
}
