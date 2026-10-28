-- Estrutura inicial sugerida para Supabase
-- Configure Authentication e habilite RLS antes de usar com dados reais.
-- Não exponha service_role key no navegador.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text,
  role text not null default 'consulta' check (role in ('administrador','editor','consulta')),
  created_at timestamptz not null default now()
);

create table if not exists public.frota_equipamentos (
  id uuid primary key default gen_random_uuid(),
  prefixo text not null unique,
  categoria text,
  modelo text,
  numero_serie text,
  obra text,
  localizacao text,
  status text,
  data_entrada date,
  defeito_intervencao text,
  data_inicio_parada date,
  previsao_retorno date,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.frota_manutencoes (
  id uuid primary key default gen_random_uuid(),
  equipamento_id uuid references public.frota_equipamentos(id) on delete set null,
  tipo text,
  descricao text,
  data_abertura date,
  data_prevista date,
  data_conclusao date,
  responsavel text,
  status text,
  observacoes text,
  created_at timestamptz not null default now()
);

create table if not exists public.frota_calibracoes (
  id uuid primary key default gen_random_uuid(),
  equipamento_id uuid references public.frota_equipamentos(id) on delete cascade,
  tipo text,
  data_ultima date,
  data_vencimento date,
  responsavel text,
  status text,
  observacoes text,
  created_at timestamptz not null default now()
);

create table if not exists public.frota_emissoes (
  id uuid primary key default gen_random_uuid(),
  equipamento_id uuid references public.frota_equipamentos(id) on delete cascade,
  obra text,
  data_ultimo_teste date,
  data_vencimento date,
  ciclo_dias integer default 180,
  status text,
  observacoes text,
  created_at timestamptz not null default now()
);

create table if not exists public.frota_movimentacoes (
  id uuid primary key default gen_random_uuid(),
  equipamento_id uuid references public.frota_equipamentos(id) on delete set null,
  data_movimentacao date,
  origem text,
  destino text,
  tipo text,
  responsavel text,
  observacoes text,
  created_at timestamptz not null default now()
);

-- Antes de habilitar acesso pela API, habilite RLS em TODAS as tabelas
-- e crie políticas para que apenas usuários autenticados acessem os dados.
-- As permissões por perfil (administrador/editor/consulta) devem ser implementadas
-- com políticas testadas; não publique este banco sem concluir essa etapa.
