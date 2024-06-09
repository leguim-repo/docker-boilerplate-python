import uvicorn
from fastapi import FastAPI

from infrastructure.api.v1 import main

the_app = FastAPI()

the_app.include_router(main.router)

if __name__ == '__main__':
    uvicorn.run(the_app, host="0.0.0.0", port=9000)
