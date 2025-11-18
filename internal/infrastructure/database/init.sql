CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS files CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT NOT NULL,
    password TEXT NOT NULL CHECK (length(password) >= 6),
    email TEXT NOT NULL,
    role TEXT NOT NULL,
    CONSTRAINT users_username_key UNIQUE(username),
    CONSTRAINT users_mail_key UNIQUE(email)
);

CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    name TEXT NOT NULL,
    password TEXT,
    type TEXT,
    size BIGINT,
    created_at TIMESTAMPTZ DEFAULT now(),
    available_from TIMESTAMPTZ,
    available_to TIMESTAMPTZ,
    enable_totp BOOLEAN DEFAULT false,
    share_token TEXT,
    CONSTRAINT files_password_check CHECK (length(password) >= 6),
    CONSTRAINT files_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE shared (
    user_id UUID NOT NULL,
    file_id UUID NOT NULL,
    PRIMARY KEY (user_id, file_id),
    CONSTRAINT shared_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT shared_file_id_fkey FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE
);

CREATE TABLE download (
    download_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    time TIMESTAMPTZ DEFAULT now(),
    user_id UUID,
    file_id UUID NOT NULL,
    CONSTRAINT download_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT download_file_id_fkey FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE
);

INSERT INTO users (username, password, email, role)
VALUES
    ('giang', '123456', 'giang@example.com', 'admin'),
    ('tuan', 'abcdef', 'tuan@example.com', 'user'),
    ('haixon', 'password', 'haixon@example.com', 'user');

SELECT * FROM users;
