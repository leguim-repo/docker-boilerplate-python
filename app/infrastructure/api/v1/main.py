from fastapi import APIRouter

from any_module.the_module import say_hello

router = APIRouter()


@router.get("/", tags=["main"])
async def main():
    return [{"username": "Rick"}, {"username": "Morty"}]


@router.get("/hello", tags=["hello"])
async def hello():
    return {"response": say_hello()}
