-- Table: public.usuario

-- DROP TABLE public.usuario;

CREATE TABLE IF NOT EXISTS public.usuario
(
    id bigserial NOT NULL,
    nome character varying(50) NOT NULL,
    kafka timestamp without time zone NOT NULL,
    CONSTRAINT usuario_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

-- Index: kafka_usuario_idx

-- DROP INDEX public.kafka_usuario_idx;

CREATE INDEX IF NOT EXISTS kafka_usuario_idx
    ON public.usuario USING btree
    (kafka ASC NULLS LAST)
    TABLESPACE pg_default;