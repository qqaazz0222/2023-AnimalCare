import speech_recognition as sr
import websocket 
import threading

# Audio recording and recognition function
def recognize_audio():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        print("Recording...")
        audio = recognizer.listen(source, phrase_time_limit=5)

    try:
        text = recognizer.recognize_google(audio, language="en-US")
        print("Recognized result:", text)
        return text
    except sr.UnknownValueError:
        print("Recognition failed.")
        return None

# Function to send text over WebSocket
def send_data_over_websocket(text):
    def on_open(ws):
        if text is not None:
            ws.send(text)
            print("Text sent:", text)

    websocket.enableTrace(True)
    ws = websocket.WebSocketApp("ws:localhost:8000", on_open=on_open)
    ws.on_open = on_open
    ws.run_forever()

# Execute recording and WebSocket transmission
if __name__ == '__main__':
    recognized_text = recognize_audio()
    if recognized_text is not None:
        send_data_over_websocket(recognized_text)
