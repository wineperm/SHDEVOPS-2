import sentry_sdk

sentry_sdk.init(
    dsn="https://ae4ea9511012d843ede371eae6b28ff1@o4506993690017792.ingest.us.sentry.io/4506993832427520",
    release="1.0"
)

if __name__ == "__main__":
    division_zero = 1 / 0