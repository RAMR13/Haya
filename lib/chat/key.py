import requests
import pyotp
import hashlib
import base64

# Fill in your email address, gist URL, and solution language
email = "amroabedalqader@gmail.com"
gist_url = "https://gist.github.com/RAMR13/45504e22286a64f3085cec09fbaac105"
solution_language = "python"  # or "golang"

# Step 1: Set up the Token Shared Secret
user_id = email
token_shared_secret = user_id + "HENNGECHALLENGE003"

# Base32 encode the shared secret
encoded_shared_secret = base64.b32encode(token_shared_secret.encode()).decode()

# Step 2: Generate the TOTP Password
totp = pyotp.TOTP(encoded_shared_secret, digest=hashlib.sha512, interval=30,digits=10)
password = totp.now()

# Step 3: Construct the Authorization Header
credentials = f"{user_id}:{password}"
authorization_header = {"Authorization": "Basic " + base64.b64encode(credentials.encode()).decode()}

# Step 4: Construct the JSON payload
json_payload = {
    "github_url": gist_url,
    "contact_email": email,
    "solution_language": solution_language
}

# Step 5: Make the HTTP POST request
url = "https://api.challenge.hennge.com/challenges/003"
headers = {"Content-Type": "application/json"}
response = requests.post(url, json=json_payload, headers={**headers, **authorization_header})

# Step 6: Print the response
print(response.status_code)
print(response.json())
