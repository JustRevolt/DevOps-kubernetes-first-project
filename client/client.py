import urllib.request

client = urllib.request.urlopen("http://127.0.0.1:9057/")

# Декодирование ответа
# encodedContent = client.read()
# decodedContent = encodedContent.decode("utf8")

print("decodedContent")

client.close()