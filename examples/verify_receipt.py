"""Verify a Confirme receipt offline.

    pip install pynacl requests
    python verify_receipt.py recu.json

The receipt is the `recu` object returned by any Confirme call. The public key is
fetched once from https://www.synapseconnexion.com/ia/cle (Ed25519, base64).
"""
import base64
import json
import sys

import requests
from nacl.exceptions import BadSignatureError
from nacl.signing import VerifyKey

CLE_URL = "https://www.synapseconnexion.com/ia/cle"


def verify(recu: dict) -> bool:
    cle = requests.get(CLE_URL, timeout=15).json()
    if recu.get("cle_id") not in (None, cle["id"]):
        return False
    canon = "\n".join([recu["id"], recu["horodatage"], recu["service"], recu["demande_sha256"], recu["resultat_sha256"]]).encode("utf-8")
    try:
        VerifyKey(base64.b64decode(cle["publique_base64"])).verify(canon, base64.b64decode(recu["signature_base64"]))
        return True
    except BadSignatureError:
        return False


if __name__ == "__main__":
    data = json.load(open(sys.argv[1], encoding="utf-8"))
    recu = data.get("recu", data)
    ok = verify(recu)
    print("valide" if ok else "NON valide", recu.get("service"), recu.get("horodatage"))
    sys.exit(0 if ok else 1)
