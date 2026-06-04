import os
import time

from sqlalchemy.exc import OperationalError
from werkzeug.security import generate_password_hash

from app import create_app, db
from app.models import User


def initialize_database() -> None:
    app = create_app()
    retries = int(os.getenv("DB_INIT_RETRIES", "30"))
    delay = int(os.getenv("DB_INIT_DELAY_SECONDS", "2"))

    with app.app_context():
        for attempt in range(1, retries + 1):
            try:
                db.create_all()

                if User.query.count() == 0:
                    db.session.add_all(
                        [
                            User(
                                username="admin",
                                password_hash=generate_password_hash("admin123"),
                            ),
                            User(
                                username="user",
                                password_hash=generate_password_hash("user123"),
                            ),
                        ]
                    )
                    db.session.commit()

                return
            except OperationalError:
                db.session.rollback()
                if attempt == retries:
                    raise
                time.sleep(delay)


if __name__ == "__main__":
    initialize_database()
