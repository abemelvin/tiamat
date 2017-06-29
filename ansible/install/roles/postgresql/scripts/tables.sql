CREATE TABLE aliases (
    alias text NOT NULL,
    email text NOT NULL
);
CREATE TABLE users (
    email text NOT NULL,
    password text NOT NULL,
    maildir text NOT NULL,
    created timestamp with time zone DEFAULT now()
);
ALTER TABLE aliases OWNER TO mailreader;
ALTER TABLE users OWNER TO mailreader;