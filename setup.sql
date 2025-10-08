--
-- PostgreSQL database setup script
-- Final Corrected Version with snake_case naming convention
--

-- =================================================================
-- PART 1: STRUCTURE (INIT)
-- =================================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE TYPE public.supply_request_status AS ENUM (
    'IN_REVIEW',
    'APPROVED',
    'REJECTED'
);
ALTER TYPE public.supply_request_status OWNER TO postgres;

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.appearance_settings (
    id integer NOT NULL,
    mode text DEFAULT 'default'::text,
    "staticImageId" integer,
    images jsonb DEFAULT '[]'::jsonb
);
ALTER TABLE public.appearance_settings OWNER TO postgres;

CREATE TABLE public.contracts (
    id integer NOT NULL,
    "contractNumber" character varying(255) NOT NULL,
    "contractTitle" character varying(255) NOT NULL,
    "partyId" integer NOT NULL,
    "contractAmount" numeric(19,2) NOT NULL,
    "paidAmount" numeric(19,2) DEFAULT 0.00,
    "contractDate" timestamp with time zone,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    status character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    "paymentTerms" jsonb DEFAULT '[]'::jsonb,
    "unitIds" integer[]
);
ALTER TABLE public.contracts OWNER TO postgres;

CREATE SEQUENCE public.contracts_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.contracts_id_seq OWNER TO postgres;
ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;

CREATE TABLE public.debit_cards (
    id integer NOT NULL,
    "holderName" character varying(255) NOT NULL,
    "cardNumber" character varying(255) NOT NULL,
    "limit" numeric(19,2) NOT NULL
);
ALTER TABLE public.debit_cards OWNER TO postgres;

CREATE SEQUENCE public.debit_cards_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.debit_cards_id_seq OWNER TO postgres;
ALTER SEQUENCE public.debit_cards_id_seq OWNED BY public.debit_cards.id;

CREATE TABLE public.expense_reports (
    id integer NOT NULL,
    "pettyCashHolderId" integer NOT NULL,
    "totalAmount" numeric(19,2) NOT NULL,
    "submissionDate" timestamp with time zone NOT NULL,
    status character varying(50) NOT NULL,
    items jsonb NOT NULL,
    "rejectionReason" text,
    "finalApprovalDate" timestamp with time zone
);
ALTER TABLE public.expense_reports OWNER TO postgres;

CREATE SEQUENCE public.expense_reports_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.expense_reports_id_seq OWNER TO postgres;
ALTER SEQUENCE public.expense_reports_id_seq OWNED BY public.expense_reports.id;

CREATE TABLE public.internal_workflows (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "unitId" integer NOT NULL,
    steps jsonb
);
ALTER TABLE public.internal_workflows OWNER TO postgres;

CREATE SEQUENCE public.internal_workflows_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.internal_workflows_id_seq OWNER TO postgres;
ALTER SEQUENCE public.internal_workflows_id_seq OWNED BY public.internal_workflows.id;

CREATE TABLE public.persons (
    id integer NOT NULL,
    "fullName" character varying(255) NOT NULL,
    "firstName" character varying(255),
    "lastName" character varying(255),
    username character varying(255),
    password character varying(255),
    "nationalId" character varying(20),
    "isSystemUser" boolean DEFAULT false,
    "isBeneficiary" boolean DEFAULT false,
    "accountNumber" character varying(100),
    "cardNumber" character varying(100),
    iban character varying(100),
    address text,
    phone character varying(50),
    "roleIds" integer[],
    "unitId" integer,
    status character varying(50) DEFAULT 'ACTIVE'::character varying,
    "forcePasswordChange" boolean DEFAULT false,
    "passwordNoExpiration" boolean DEFAULT false,
    "pettyCashLimit" numeric(19,2),
    "pettyCashBalance" numeric(19,2),
    "personType" character varying(50) DEFAULT 'NATURAL'::character varying,
    "personnelCode" character varying(255),
    email character varying(255)
);
ALTER TABLE public.persons OWNER TO postgres;

CREATE SEQUENCE public.persons_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.persons_id_seq OWNER TO postgres;
ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    manager character varying(255),
    budget numeric(15,2)
);
ALTER TABLE public.projects OWNER TO postgres;

CREATE SEQUENCE public.projects_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.projects_id_seq OWNER TO postgres;
ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;

CREATE TABLE public.request_categories (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    label character varying(255) NOT NULL,
    attachments jsonb,
    subtypes jsonb,
    "deadlineDays" integer
);
ALTER TABLE public.request_categories OWNER TO postgres;

CREATE SEQUENCE public.request_categories_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.request_categories_id_seq OWNER TO postgres;
ALTER SEQUENCE public.request_categories_id_seq OWNED BY public.request_categories.id;

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    permissions jsonb,
    status character varying(50)
);
ALTER TABLE public.roles OWNER TO postgres;

CREATE SEQUENCE public.roles_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.roles_id_seq OWNER TO postgres;
ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;

CREATE TABLE public.supply_requests (
    id character varying(255) NOT NULL,
    "workflowId" integer NOT NULL,
    "_activeSteps" jsonb,
    _history jsonb,
    "requestTypeId" integer NOT NULL,
    "requesterId" integer NOT NULL,
    "requestingUnitId" integer NOT NULL,
    amount numeric(19,2) NOT NULL,
    currency character varying(10) NOT NULL,
    status public.supply_request_status NOT NULL,
    "submissionDate" text,
    "submissionDateForSort" timestamp with time zone,
    "dueDate" timestamp with time zone,
    "itemDescription" text,
    "fundingSource" character varying(50),
    "expenseType" character varying(50),
    "imprestHolderId" integer,
    attachments jsonb,
    invoices jsonb,
    "contractId" integer,
    "paymentTermDescription" text,
    "_internalReview" jsonb
);
ALTER TABLE public.supply_requests OWNER TO postgres;

CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50),
    "parentId" integer,
    credit numeric(19,2)
);
ALTER TABLE public.units OWNER TO postgres;

CREATE SEQUENCE public.units_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.units_id_seq OWNER TO postgres;
ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;

CREATE TABLE public.workflows (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "requestCategoryId" integer NOT NULL,
    steps jsonb
);
ALTER TABLE public.workflows OWNER TO postgres;

CREATE SEQUENCE public.workflows_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.workflows_id_seq OWNER TO postgres;
ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);
ALTER TABLE ONLY public.debit_cards ALTER COLUMN id SET DEFAULT nextval('public.debit_cards_id_seq'::regclass);
ALTER TABLE ONLY public.expense_reports ALTER COLUMN id SET DEFAULT nextval('public.expense_reports_id_seq'::regclass);
ALTER TABLE ONLY public.internal_workflows ALTER COLUMN id SET DEFAULT nextval('public.internal_workflows_id_seq'::regclass);
ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);
ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);
ALTER TABLE ONLY public.request_categories ALTER COLUMN id SET DEFAULT nextval('public.request_categories_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);
ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);

ALTER TABLE ONLY public.appearance_settings ADD CONSTRAINT appearance_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.contracts ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.debit_cards ADD CONSTRAINT debit_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expense_reports ADD CONSTRAINT expense_reports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.internal_workflows ADD CONSTRAINT internal_workflows_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.persons ADD CONSTRAINT persons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.persons ADD CONSTRAINT persons_username_key UNIQUE (username);
ALTER TABLE ONLY public.projects ADD CONSTRAINT projects_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.request_categories ADD CONSTRAINT request_categories_key_key UNIQUE (key);
ALTER TABLE ONLY public.request_categories ADD CONSTRAINT request_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.roles ADD CONSTRAINT roles_name_key UNIQUE (name);
ALTER TABLE ONLY public.roles ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.units ADD CONSTRAINT units_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.workflows ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.contracts ADD CONSTRAINT contracts_partyId_fkey FOREIGN KEY ("partyId") REFERENCES public.persons(id);
ALTER TABLE ONLY public.expense_reports ADD CONSTRAINT expense_reports_pettyCashHolderId_fkey FOREIGN KEY ("pettyCashHolderId") REFERENCES public.persons(id);
ALTER TABLE ONLY public.internal_workflows ADD CONSTRAINT internal_workflows_unitId_fkey FOREIGN KEY ("unitId") REFERENCES public.units(id);
ALTER TABLE ONLY public.persons ADD CONSTRAINT persons_unitId_fkey FOREIGN KEY ("unitId") REFERENCES public.units(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_imprestHolderId_fkey FOREIGN KEY ("imprestHolderId") REFERENCES public.persons(id);
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_requesterId_fkey FOREIGN KEY ("requesterId") REFERENCES public.persons(id);
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_requestingUnitId_fkey FOREIGN KEY ("requestingUnitId") REFERENCES public.units(id);
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_requestTypeId_fkey FOREIGN KEY ("requestTypeId") REFERENCES public.request_categories(id);
ALTER TABLE ONLY public.supply_requests ADD CONSTRAINT supply_requests_workflowId_fkey FOREIGN KEY ("workflowId") REFERENCES public.workflows(id);
ALTER TABLE ONLY public.units ADD CONSTRAINT units_parentId_fkey FOREIGN KEY ("parentId") REFERENCES public.units(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.workflows ADD CONSTRAINT workflows_requestCategoryId_fkey FOREIGN KEY ("requestCategoryId") REFERENCES public.request_categories(id) ON DELETE CASCADE;


-- =================================================================
-- PART 2: DATA (SEED)
-- =================================================================

INSERT INTO public.roles (id, name, description, permissions, status) VALUES
(1, 'مدیر سیستم', 'دسترسی کامل به تمام بخش‌های سیستم', '["DASHBOARD:read", "DASHBOARD:create", "REPORTS:read", "UNITS:read", "UNITS:create", "UNITS:update", "UNITS:delete", "PROJECTS:read", "PROJECTS:create", "PROJECTS:update", "PROJECTS:delete", "PERSONS:read", "PERSONS:create", "PERSONS:update", "PERSONS:delete", "BENEFICIARIES:read", "BENEFICIARIES:create", "BENEFICIARIES:update", "BENEFICIARIES:delete", "ROLES:read", "ROLES:create", "ROLES:update", "ROLES:delete", "WORKFLOW:read", "WORKFLOW:create", "WORKFLOW:update", "WORKFLOW:delete", "CONTRACTS:read", "CONTRACTS:create", "CONTRACTS:update", "CONTRACTS:delete", "INTERNAL_WORKFLOWS:read", "INTERNAL_WORKFLOWS:create", "INTERNAL_WORKFLOWS:update", "INTERNAL_WORKFLOWS:delete", "DEBIT:read", "DEBIT:create", "DEBIT:update", "DEBIT:delete", "REQUEST_TYPES:read", "REQUEST_TYPES:create", "REQUEST_TYPES:update", "REQUEST_TYPES:delete", "PROFILE:read", "PROFILE:update", "SECURITY:read", "SECURITY:create", "SECURITY:update", "SECURITY:delete", "APPEARANCE:read", "APPEARANCE:update", "PETTY_CASH_MANAGEMENT:read_all", "PETTY_CASH_MANAGEMENT:update", "BACKUP:read", "BACKUP:create"]', 'ACTIVE'),
(2, 'مدیر واحد', 'دسترسی مدیریتی در سطح واحد سازمانی خود', '["DASHBOARD:read", "DASHBOARD:create", "REPORTS:read", "PETTY_CASH_MANAGEMENT:read_own_unit", "PETTY_CASH_MANAGEMENT:update"]', 'ACTIVE'),
(3, 'کاربر', 'دسترسی برای ثبت و پیگیری درخواست‌های خود', '["DASHBOARD:read", "DASHBOARD:create", "PROFILE:read", "PROFILE:update"]', 'ACTIVE'),
(15, 'تنخواه گردان', 'دسترسی به ماژول تنخواه', '["DASHBOARD:read", "DASHBOARD:create", "PETTY_CASH:read", "PETTY_CASH:create", "PROFILE:read", "PROFILE:update"]', 'ACTIVE');

INSERT INTO public.units (id, name, code, "parentId") VALUES
(1, 'سازمان', 'ORG-001', NULL);

INSERT INTO public.persons (id, "fullName", "firstName", "lastName", username, password, "isSystemUser", "isBeneficiary", "roleIds", "unitId", status) VALUES
(1, 'مدیر سیستم', 'مدیر', 'سیستم', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', true, false, '{1}', 1, 'ACTIVE');

INSERT INTO public.request_categories (id, key, label, attachments, subtypes, "deadlineDays") VALUES
(1, 'DIRECT_PURCHASE', 'خرید مستقیم', '["پیش فاکتور"]', '[]', 7),
(2, 'PETTY_CASH', 'تنخواه', '[]', '[]', 3),
(3, 'CONTRACT', 'پرداخت قرارداد', '[]', '[{"id": 1, "label": "پیش پرداخت"}, {"id": 2, "label": "صورت وضعیت"}, {"id": 3, "label": "حسن انجام کار"}]', 10),
(4, 'SALARY_ADVANCE', 'مساعده حقوق', '[]', '[]', 2);

-- Reset sequences to prevent key collision after manual inserts
SELECT setval('public.roles_id_seq', (SELECT MAX(id) FROM public.roles));
SELECT setval('public.persons_id_seq', (SELECT MAX(id) from public.persons));
SELECT setval('public.units_id_seq', (SELECT MAX(id) from public.units));
SELECT setval('public.request_categories_id_seq', (SELECT MAX(id) from public.request_categories));

--
-- PostgreSQL database setup complete
--