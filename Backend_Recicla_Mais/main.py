from typing import List, Optional
from enum import Enum
from datetime import datetime
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

app = FastAPI(title="Recicla Mais Backend")

# Configurar CORS para permitir requisições do Flutter Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite todas as origens (para desenvolvimento)
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos os métodos (GET, POST, PUT, DELETE, etc.)
    allow_headers=["*"],  # Permite todos os headers
)

# --- Modelos de Dados (Espelhando o Flutter) ---
class UserType(str, Enum):
    citizen = "citizen"
    collector = "collector"
    admin = "admin"

class UserModel(BaseModel):
    id: str
    nomeCompleto: str
    email: str
    senha: str
    dataNascimento: Optional[str] = None
    genero: Optional[str] = None
    cidadeEstado: Optional[str] = None
    endereco: Optional[str] = None
    telefone: Optional[str] = None
    userType: UserType = UserType.citizen
    fotoUrl: Optional[str] = None

class UserResponseModel(BaseModel):
    """Modelo de resposta de usuário sem expor a senha"""
    id: str
    nomeCompleto: str
    email: str
    dataNascimento: Optional[str] = None
    genero: Optional[str] = None
    cidadeEstado: Optional[str] = None
    endereco: Optional[str] = None
    telefone: Optional[str] = None
    userType: UserType = UserType.citizen
    fotoUrl: Optional[str] = None

class UserLoginModel(BaseModel):
    email: str
    senha: str

class CollectionStatus(str, Enum):
    available = "available"
    pending = "pending"
    completed = "completed"
    approved = "approved"
    rejected = "rejected"

class CollectionModel(BaseModel):
    collectionCode: str
    tempoColeta: str
    distanciaKm: str
    nomeSolicitante: str
    endereco: str
    referencia: str
    tipoMaterial: str
    pesoEstimado: str
    detalhesAdicionais: str
    observacoes: str
    bairro: str
    status: CollectionStatus = CollectionStatus.available
    # Novos campos solicitados
    imageUrl: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None

class NotificationType(str, Enum):
    info = "info"
    success = "success"
    warning = "warning"
    error = "error"

class NotificationModel(BaseModel):
    id: str
    userId: str
    title: str
    message: str
    type: NotificationType = NotificationType.info
    isRead: bool = False
    timestamp: datetime = Field(default_factory=datetime.now)

class ChatMessageModel(BaseModel):
    id: str
    text: str
    isFromCollector: bool
    timestamp: str # Simplificado para string para este exemplo
    collectionCode: Optional[str] = None # Novo campo solicitado

# --- Banco de Dados Fictício (Vetor em Memória) ---
db_usuarios : List[UserModel] = [
    # Usuário Administrador
    UserModel(
        id="admin_001",
        nomeCompleto="Maria Silva",
        email="admin@recicla.com",
        senha="admin123",
        dataNascimento="1985-05-15",
        genero="Feminino",
        cidadeEstado="Petrolina, PE",
        endereco="Rua da Administração, 100",
        telefone="(87) 98765-4321",
        userType=UserType.admin,
        fotoUrl="https://i.pravatar.cc/150?img=47"
    ),
    # Usuário Coletor
    UserModel(
        id="col_001",
        nomeCompleto="João Santos",
        email="coletor@recicla.com",
        senha="coletor123",
        dataNascimento="1990-08-22",
        genero="Masculino",
        cidadeEstado="Petrolina, PE",
        endereco="Rua dos Coletores, 250",
        telefone="(87) 99876-5432",
        userType=UserType.collector,
        fotoUrl="https://i.pravatar.cc/150?img=12"
    ),
    # Usuário Normal (Cidadão)
    UserModel(
        id="user_001",
        nomeCompleto="Ana Costa",
        email="usuario@recicla.com",
        senha="usuario123",
        dataNascimento="1995-03-10",
        genero="Feminino",
        cidadeEstado="Petrolina, PE",
        endereco="Rua das Flores, 45",
        telefone="(87) 97654-3210",
        userType=UserType.citizen,
        fotoUrl="https://i.pravatar.cc/150?img=25"
    )
]
db_collections: List[CollectionModel] = [
    CollectionModel(
        tempoColeta='Amanhã, 08:00 - 10:00',
        distanciaKm='1.2 km',
        nomeSolicitante='João Souza',
        endereco='Rua das Flores, 45',
        referencia='Próximo ao mercado',
        tipoMaterial='Eletrônicos',
        pesoEstimado='3kg',
        detalhesAdicionais='Teclados, mouses e cabos antigos.',
        observacoes='Ligar antes de chegar.',
        collectionCode='11223',
        bairro='Primavera',
        status=CollectionStatus.available,
        latitude=-9.398,
        longitude=-40.500
    ),
    CollectionModel(
        tempoColeta='Amanhã, 14:00 - 16:00',
        distanciaKm='8.5 km',
        nomeSolicitante='Empresa Tech',
        endereco='Av. Industrial, 500',
        referencia='Galpão 3',
        tipoMaterial='Papel e Plástico',
        pesoEstimado='50kg',
        detalhesAdicionais='Grande quantidade de material de escritório.',
        observacoes='Procurar por Carlos na portaria.',
        collectionCode='44556',
        bairro='Senador Nilo Coelho',
        status=CollectionStatus.available,
        latitude=-9.380,
        longitude=-40.480
    ),
    CollectionModel(
        tempoColeta='Sexta, 09:00 - 11:00',
        distanciaKm='3.0 km',
        nomeSolicitante='Ana Pereira',
        endereco='Rua da Paz, 200',
        referencia='Casa amarela',
        tipoMaterial='Metal',
        pesoEstimado='15kg',
        detalhesAdicionais='Latas de alumínio e panelas velhas.',
        observacoes='Pode tocar a campainha.',
        collectionCode='77889',
        bairro='Baixão',
        status=CollectionStatus.available,
        latitude=-9.410,
        longitude=-40.510
    ),
    CollectionModel(
        tempoColeta='Hoje, 10:00 - 12:00',
        distanciaKm='2.1 km',
        nomeSolicitante='Carlos Lima',
        endereco='Rua das Mangueiras, 150',
        referencia='Em frente à padaria Pão Quente',
        tipoMaterial='Vidro',
        pesoEstimado='10kg',
        detalhesAdicionais='Garrafas de cerveja e potes de conserva.',
        observacoes='Material na calçada.',
        collectionCode='54321',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.390,
        longitude=-40.505
    ),
    CollectionModel(
        tempoColeta='Amanhã, 13:00 - 15:00',
        distanciaKm='4.5 km',
        nomeSolicitante='Fernanda Oliveira',
        endereco='Av. dos Navegantes, 789',
        referencia='Prédio com sacada de vidro',
        tipoMaterial='Plástico (PET)',
        pesoEstimado='5kg',
        detalhesAdicionais='Garrafas de refrigerante amassadas.',
        observacoes='Deixar na portaria com o Sr. José.',
        collectionCode='98765',
        bairro='Gercino Coelho',
        status=CollectionStatus.available,
        latitude=-9.405,
        longitude=-40.495
    ),
    CollectionModel(
        tempoColeta='Hoje, 16:00 - 18:00',
        distanciaKm='6.2 km',
        nomeSolicitante='Ricardo Almeida',
        endereco='Rua do Caju, 33',
        referencia='Casa de esquina com muro alto',
        tipoMaterial='Papelão',
        pesoEstimado='20kg',
        detalhesAdicionais='Caixas de papelão de mudança.',
        observacoes='Material pesado, talvez precise de ajuda.',
        collectionCode='13579',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.385,
        longitude=-40.520
    ),
    CollectionModel(
        tempoColeta='Amanhã, 08:00 - 10:00',
        distanciaKm='1.5 km',
        nomeSolicitante='Juliana Martins',
        endereco='Rua do Horizonte, 12',
        referencia='Próximo à praça principal',
        tipoMaterial='Plástico',
        pesoEstimado='4kg',
        detalhesAdicionais='Embalagens diversas limpas.',
        observacoes='Pode chamar no portão.',
        collectionCode='20001',
        bairro='José e Maria',
        status=CollectionStatus.available,
        latitude=-9.375,
        longitude=-40.510
    ),
    CollectionModel(
        tempoColeta='Hoje, 14:00 - 16:00',
        distanciaKm='3.2 km',
        nomeSolicitante='Roberto Costa',
        endereco='Av. da Integração, 500',
        referencia='Ao lado do posto de gasolina',
        tipoMaterial='Vidro',
        pesoEstimado='8kg',
        detalhesAdicionais='Garrafas de vinho e potes.',
        observacoes='Cuidado, vidro quebrado em caixa separada.',
        collectionCode='20002',
        bairro='Vila Eduardo',
        status=CollectionStatus.available,
        latitude=-9.385,
        longitude=-40.485
    ),
    CollectionModel(
        tempoColeta='Sexta, 10:00 - 12:00',
        distanciaKm='2.0 km',
        nomeSolicitante='Amanda Souza',
        endereco='Rua 15, 30',
        referencia='Perto da escola municipal',
        tipoMaterial='Metal',
        pesoEstimado='12kg',
        detalhesAdicionais='Restos de obra e latas.',
        observacoes='Ligar quando estiver chegando.',
        collectionCode='20003',
        bairro='Cohab Massangano',
        status=CollectionStatus.available,
        latitude=-9.395,
        longitude=-40.515
    ),
    CollectionModel(
        tempoColeta='Amanhã, 16:00 - 18:00',
        distanciaKm='0.8 km',
        nomeSolicitante='Felipe Rocha',
        endereco='Rua da Simpatia, 88',
        referencia='Em frente ao mercadinho',
        tipoMaterial='Papel',
        pesoEstimado='5kg',
        detalhesAdicionais='Jornais e revistas antigas.',
        observacoes='Deixar na portaria.',
        collectionCode='20004',
        bairro='Atrás da Banca',
        status=CollectionStatus.available,
        latitude=-9.392,
        longitude=-40.502
    ),
    CollectionModel(
        tempoColeta='Hoje, 09:00 - 11:00',
        distanciaKm='4.1 km',
        nomeSolicitante='Bruno Lima',
        endereco='Av. dos Tropeiros, 1020',
        referencia='Condomínio Solar',
        tipoMaterial='Eletrônicos',
        pesoEstimado='2kg',
        detalhesAdicionais='Celulares antigos e carregadores.',
        observacoes='Interfone 202.',
        collectionCode='20005',
        bairro='Jardim Amazonas',
        status=CollectionStatus.available,
        latitude=-9.388,
        longitude=-40.525
    ),
    CollectionModel(
        tempoColeta='Segunda, 13:00 - 15:00',
        distanciaKm='5.5 km',
        nomeSolicitante='Carla Dias',
        endereco='Rua do Ouro, 45',
        referencia='Próximo à igreja',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='5L',
        detalhesAdicionais='Óleo usado em garrafas PET.',
        observacoes='Bem vedado.',
        collectionCode='20006',
        bairro='Alto do Cocar',
        status=CollectionStatus.available,
        latitude=-9.378,
        longitude=-40.530
    ),
    CollectionModel(
        tempoColeta='Amanhã, 11:00 - 13:00',
        distanciaKm='2.8 km',
        nomeSolicitante='Diego Alves',
        endereco='Rua Projetada, 10',
        referencia='Casa verde',
        tipoMaterial='Plástico',
        pesoEstimado='6kg',
        detalhesAdicionais='Garrafas de água e refrigerante.',
        observacoes='Pode buzinar.',
        collectionCode='20007',
        bairro='Rio Corrente',
        status=CollectionStatus.available,
        latitude=-9.400,
        longitude=-40.510
    ),
    CollectionModel(
        tempoColeta='Hoje, 15:00 - 17:00',
        distanciaKm='1.0 km',
        nomeSolicitante='Eliana Ferreira',
        endereco='Rua Dom Vital, 200',
        referencia='Centro comercial',
        tipoMaterial='Vidro',
        pesoEstimado='15kg',
        detalhesAdicionais='Vidros de conserva.',
        observacoes='Entrada pelos fundos.',
        collectionCode='20008',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.395,
        longitude=-40.500
    ),
    CollectionModel(
        tempoColeta='Quinta, 08:00 - 10:00',
        distanciaKm='3.5 km',
        nomeSolicitante='Fabio Gomes',
        endereco='Rua do Caju, 150',
        referencia='Perto da feira',
        tipoMaterial='Metal',
        pesoEstimado='20kg',
        detalhesAdicionais='Sucata de ferro.',
        observacoes='Material pesado.',
        collectionCode='20009',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.382,
        longitude=-40.518
    ),
    CollectionModel(
        tempoColeta='Amanhã, 14:00 - 16:00',
        distanciaKm='1.9 km',
        nomeSolicitante='Gisele Ribeiro',
        endereco='Av. Nilo Coelho, 300',
        referencia='Prédio azul',
        tipoMaterial='Papel',
        pesoEstimado='10kg',
        detalhesAdicionais='Arquivos mortos de escritório.',
        observacoes='Procurar recepção.',
        collectionCode='20010',
        bairro='Gercino Coelho',
        status=CollectionStatus.available,
        latitude=-9.402,
        longitude=-40.498
    ),
    CollectionModel(
        tempoColeta='Sexta, 09:00 - 11:00',
        distanciaKm='2.3 km',
        nomeSolicitante='Hugo Santos',
        endereco='Rua da Polônia, 55',
        referencia='Rua sem saída',
        tipoMaterial='Eletrônicos',
        pesoEstimado='4kg',
        detalhesAdicionais='Monitor antigo e cabos.',
        observacoes='Ligar antes.',
        collectionCode='20011',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.384,
        longitude=-40.515
    ),
    CollectionModel(
        tempoColeta='Hoje, 10:00 - 12:00',
        distanciaKm='4.0 km',
        nomeSolicitante='Iara Barbosa',
        endereco='Rua 20, 12',
        referencia='Perto do canal',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='2L',
        detalhesAdicionais='Garrafas PET.',
        observacoes='Deixarei na calçada se não estiver.',
        collectionCode='20012',
        bairro='Jardim Amazonas',
        status=CollectionStatus.available,
        latitude=-9.390,
        longitude=-40.528
    ),
    CollectionModel(
        tempoColeta='Amanhã, 13:00 - 15:00',
        distanciaKm='1.7 km',
        nomeSolicitante='Jorge Silva',
        endereco='Rua Pacifica, 77',
        referencia='Muro branco',
        tipoMaterial='Plástico',
        pesoEstimado='3kg',
        detalhesAdicionais='Brinquedos quebrados.',
        observacoes='Tocar campainha.',
        collectionCode='20013',
        bairro='Vila Eduardo',
        status=CollectionStatus.available,
        latitude=-9.387,
        longitude=-40.488
    ),
    CollectionModel(
        tempoColeta='Segunda, 08:00 - 10:00',
        distanciaKm='3.0 km',
        nomeSolicitante='Karina Melo',
        endereco='Av. Sete de Setembro, 1500',
        referencia='Condomínio fechado',
        tipoMaterial='Vidro',
        pesoEstimado='5kg',
        detalhesAdicionais='Garrafas de suco.',
        observacoes='Portaria libera entrada.',
        collectionCode='20014',
        bairro='José e Maria',
        status=CollectionStatus.available,
        latitude=-9.372,
        longitude=-40.508
    ),
    CollectionModel(
        tempoColeta='Hoje, 16:00 - 18:00',
        distanciaKm='2.5 km',
        nomeSolicitante='Leandro Nunes',
        endereco='Rua do Trabalho, 90',
        referencia='Oficina mecânica',
        tipoMaterial='Metal',
        pesoEstimado='30kg',
        detalhesAdicionais='Peças de carro velhas.',
        observacoes='Precisa de carro grande.',
        collectionCode='20015',
        bairro='Atrás da Banca',
        status=CollectionStatus.available,
        latitude=-9.394,
        longitude=-40.504
    ),
    CollectionModel(
        tempoColeta='Amanhã, 09:00 - 11:00',
        distanciaKm='5.0 km',
        nomeSolicitante='Mariana Castro',
        endereco='Rua das Pedras, 33',
        referencia='Casa de esquina',
        tipoMaterial='Papel',
        pesoEstimado='8kg',
        detalhesAdicionais='Livros didáticos antigos.',
        observacoes='Doação.',
        collectionCode='20016',
        bairro='Alto do Cocar',
        status=CollectionStatus.available,
        latitude=-9.376,
        longitude=-40.532
    ),
    CollectionModel(
        tempoColeta='Quinta, 14:00 - 16:00',
        distanciaKm='1.2 km',
        nomeSolicitante='Nelson Pinto',
        endereco='Rua Souza Filho, 400',
        referencia='Loja de sapatos',
        tipoMaterial='Eletrônicos',
        pesoEstimado='1kg',
        detalhesAdicionais='Pilhas e baterias.',
        observacoes='Entregar ao gerente.',
        collectionCode='20017',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.396,
        longitude=-40.501
    ),
    CollectionModel(
        tempoColeta='Sexta, 10:00 - 12:00',
        distanciaKm='2.9 km',
        nomeSolicitante='Olivia Mendes',
        endereco='Rua da Harmonia, 123',
        referencia='Próximo ao parque',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='3L',
        detalhesAdicionais='Garrafas bem fechadas.',
        observacoes='Ligar quando chegar.',
        collectionCode='20018',
        bairro='Cohab Massangano',
        status=CollectionStatus.available,
        latitude=-9.397,
        longitude=-40.517
    ),
    CollectionModel(
        tempoColeta='Hoje, 13:00 - 15:00',
        distanciaKm='3.8 km',
        nomeSolicitante='Paulo Azevedo',
        endereco='Av. Honorato Viana, 2000',
        referencia='Em frente ao supermercado',
        tipoMaterial='Plástico',
        pesoEstimado='10kg',
        detalhesAdicionais='Caixotes de feira quebrados.',
        observacoes='Estão no fundo da loja.',
        collectionCode='20019',
        bairro='Gercino Coelho',
        status=CollectionStatus.available,
        latitude=-9.404,
        longitude=-40.496
    ),
    CollectionModel(
        tempoColeta='Amanhã, 08:00 - 10:00',
        distanciaKm='4.5 km',
        nomeSolicitante='Quezia Ramos',
        endereco='Rua do Sol, 50',
        referencia='Casa amarela',
        tipoMaterial='Vidro',
        pesoEstimado='2kg',
        detalhesAdicionais='Potes de vidro.',
        observacoes='Cuidado, frágil.',
        collectionCode='20020',
        bairro='Rio Corrente',
        status=CollectionStatus.available,
        latitude=-9.402,
        longitude=-40.512
    ),
    CollectionModel(
        tempoColeta='Segunda, 15:00 - 17:00',
        distanciaKm='1.8 km',
        nomeSolicitante='Rafael Carvalho',
        endereco='Rua Tobias Barreto, 88',
        referencia='Próximo à farmácia',
        tipoMaterial='Metal',
        pesoEstimado='5kg',
        detalhesAdicionais='Panelas velhas.',
        observacoes='Pode tocar a campainha.',
        collectionCode='20021',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.393,
        longitude=-40.503
    ),
    CollectionModel(
        tempoColeta='Hoje, 09:00 - 11:00',
        distanciaKm='3.3 km',
        nomeSolicitante='Sabrina Teixeira',
        endereco='Rua das Laranjeiras, 22',
        referencia='Muro verde',
        tipoMaterial='Papel',
        pesoEstimado='15kg',
        detalhesAdicionais='Jornais acumulados.',
        observacoes='Ajudo a carregar.',
        collectionCode='20022',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.383,
        longitude=-40.519
    ),
    CollectionModel(
        tempoColeta='Amanhã, 14:00 - 16:00',
        distanciaKm='2.2 km',
        nomeSolicitante='Tiago Correia',
        endereco='Rua da Esperança, 101',
        referencia='Perto da padaria',
        tipoMaterial='Eletrônicos',
        pesoEstimado='3kg',
        detalhesAdicionais='Impressora quebrada.',
        observacoes='Ligar antes.',
        collectionCode='20023',
        bairro='Vila Eduardo',
        status=CollectionStatus.available,
        latitude=-9.386,
        longitude=-40.486
    ),
    CollectionModel(
        tempoColeta='Quinta, 10:00 - 12:00',
        distanciaKm='4.8 km',
        nomeSolicitante='Ursula Vieira',
        endereco='Rua do Vento, 60',
        referencia='Casa de andar',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='4L',
        detalhesAdicionais='Óleo de fritura.',
        observacoes='Garrafas limpas.',
        collectionCode='20024',
        bairro='Jardim Amazonas',
        status=CollectionStatus.available,
        latitude=-9.389,
        longitude=-40.526
    ),
    CollectionModel(
        tempoColeta='Sexta, 13:00 - 15:00',
        distanciaKm='1.4 km',
        nomeSolicitante='Vitor Macedo',
        endereco='Rua Aristarco Lopes, 200',
        referencia='Centro médico',
        tipoMaterial='Plástico',
        pesoEstimado='7kg',
        detalhesAdicionais='Embalagens de produtos de limpeza.',
        observacoes='Deixar na portaria.',
        collectionCode='20025',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.398,
        longitude=-40.502
    ),
    CollectionModel(
        tempoColeta='Hoje, 16:00 - 18:00',
        distanciaKm='3.6 km',
        nomeSolicitante='Wagner Cruz',
        endereco='Rua da Alegria, 30',
        referencia='Perto do campo de futebol',
        tipoMaterial='Vidro',
        pesoEstimado='3kg',
        detalhesAdicionais='Garrafas de cerveja.',
        observacoes='Pode levar o engradado.',
        collectionCode='20026',
        bairro='Cohab Massangano',
        status=CollectionStatus.available,
        latitude=-9.396,
        longitude=-40.516
    ),
    CollectionModel(
        tempoColeta='Amanhã, 08:00 - 10:00',
        distanciaKm='5.2 km',
        nomeSolicitante='Ximena Lopes',
        endereco='Rua do Futuro, 11',
        referencia='Casa com grade branca',
        tipoMaterial='Metal',
        pesoEstimado='8kg',
        detalhesAdicionais='Tubos de ferro.',
        observacoes='Material no quintal.',
        collectionCode='20027',
        bairro='Alto do Cocar',
        status=CollectionStatus.available,
        latitude=-9.377,
        longitude=-40.531
    ),
    CollectionModel(
        tempoColeta='Segunda, 14:00 - 16:00',
        distanciaKm='2.7 km',
        nomeSolicitante='Yasmin Reis',
        endereco='Rua da Paz, 99',
        referencia='Próximo à escola',
        tipoMaterial='Papel',
        pesoEstimado='6kg',
        detalhesAdicionais='Cadernos usados.',
        observacoes='Sem espiral.',
        collectionCode='20028',
        bairro='José e Maria',
        status=CollectionStatus.available,
        latitude=-9.374,
        longitude=-40.509
    ),
    CollectionModel(
        tempoColeta='Hoje, 10:00 - 12:00',
        distanciaKm='1.6 km',
        nomeSolicitante='Zeca Camargo',
        endereco='Rua do Imperador, 500',
        referencia='Prédio comercial',
        tipoMaterial='Eletrônicos',
        pesoEstimado='5kg',
        detalhesAdicionais='Computadores velhos.',
        observacoes='Falar com TI.',
        collectionCode='20029',
        bairro='Atrás da Banca',
        status=CollectionStatus.available,
        latitude=-9.393,
        longitude=-40.505
    ),
    CollectionModel(
        tempoColeta='Amanhã, 15:00 - 17:00',
        distanciaKm='4.2 km',
        nomeSolicitante='Alice Braga',
        endereco='Rua das Flores, 202',
        referencia='Jardim florido',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='1L',
        detalhesAdicionais='Garrafa PET.',
        observacoes='Pode tocar a campainha.',
        collectionCode='20030',
        bairro='Rio Corrente',
        status=CollectionStatus.available,
        latitude=-9.401,
        longitude=-40.511
    ),
    CollectionModel(
        tempoColeta='Quinta, 09:00 - 11:00',
        distanciaKm='2.1 km',
        nomeSolicitante='Breno Farias',
        endereco='Av. Monsenhor Angelo, 100',
        referencia='Perto da igreja',
        tipoMaterial='Plástico',
        pesoEstimado='9kg',
        detalhesAdicionais='Cadeiras de plástico quebradas.',
        observacoes='Estão na calçada.',
        collectionCode='20031',
        bairro='Gercino Coelho',
        status=CollectionStatus.available,
        latitude=-9.403,
        longitude=-40.497
    ),
    CollectionModel(
        tempoColeta='Sexta, 14:00 - 16:00',
        distanciaKm='3.4 km',
        nomeSolicitante='Camila Neves',
        endereco='Rua do Comércio, 55',
        referencia='Loja de roupas',
        tipoMaterial='Vidro',
        pesoEstimado='4kg',
        detalhesAdicionais='Espelhos quebrados.',
        observacoes='Muito cuidado, embalado em papelão.',
        collectionCode='20032',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.381,
        longitude=-40.517
    ),
    CollectionModel(
        tempoColeta='Hoje, 08:00 - 10:00',
        distanciaKm='1.3 km',
        nomeSolicitante='Daniel Moraes',
        endereco='Rua Santos Dumont, 300',
        referencia='Próximo ao banco',
        tipoMaterial='Metal',
        pesoEstimado='2kg',
        detalhesAdicionais='Latas de tinta vazias.',
        observacoes='Ligar antes.',
        collectionCode='20033',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.397,
        longitude=-40.503
    ),
    CollectionModel(
        tempoColeta='Amanhã, 11:00 - 13:00',
        distanciaKm='5.8 km',
        nomeSolicitante='Elisa Cardoso',
        endereco='Rua da Serra, 12',
        referencia='Casa alta',
        tipoMaterial='Papel',
        pesoEstimado='7kg',
        detalhesAdicionais='Revistas e jornais.',
        observacoes='Deixar na garagem.',
        collectionCode='20034',
        bairro='Alto do Cocar',
        status=CollectionStatus.available,
        latitude=-9.379,
        longitude=-40.533
    ),
    CollectionModel(
        tempoColeta='Segunda, 16:00 - 18:00',
        distanciaKm='2.6 km',
        nomeSolicitante='Fernando Dantas',
        endereco='Rua do Lago, 88',
        referencia='Perto da praça',
        tipoMaterial='Eletrônicos',
        pesoEstimado='3kg',
        detalhesAdicionais='Televisão antiga pequena.',
        observacoes='Funciona, mas quero doar.',
        collectionCode='20035',
        bairro='José e Maria',
        status=CollectionStatus.available,
        latitude=-9.373,
        longitude=-40.507
    ),
    CollectionModel(
        tempoColeta='Hoje, 13:00 - 15:00',
        distanciaKm='3.9 km',
        nomeSolicitante='Gabriela Antunes',
        endereco='Rua das Palmeiras, 45',
        referencia='Muro amarelo',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='2L',
        detalhesAdicionais='Óleo usado.',
        observacoes='Garrafas PET.',
        collectionCode='20036',
        bairro='Jardim Amazonas',
        status=CollectionStatus.available,
        latitude=-9.391,
        longitude=-40.527
    ),
    CollectionModel(
        tempoColeta='Amanhã, 09:00 - 11:00',
        distanciaKm='1.8 km',
        nomeSolicitante='Henrique Sales',
        endereco='Rua do Norte, 100',
        referencia='Perto da escola',
        tipoMaterial='Plástico',
        pesoEstimado='5kg',
        detalhesAdicionais='Garrafas e potes.',
        observacoes='Pode chamar.',
        collectionCode='20037',
        bairro='Vila Eduardo',
        status=CollectionStatus.available,
        latitude=-9.388,
        longitude=-40.487
    ),
    CollectionModel(
        tempoColeta='Quinta, 15:00 - 17:00',
        distanciaKm='4.3 km',
        nomeSolicitante='Isabela Peixoto',
        endereco='Rua do Sul, 22',
        referencia='Casa de esquina',
        tipoMaterial='Vidro',
        pesoEstimado='1kg',
        detalhesAdicionais='Potes de perfume vazios.',
        observacoes='Deixar na caixa de correio se couber.',
        collectionCode='20038',
        bairro='Rio Corrente',
        status=CollectionStatus.available,
        latitude=-9.403,
        longitude=-40.513
    ),
    CollectionModel(
        tempoColeta='Sexta, 08:00 - 10:00',
        distanciaKm='2.4 km',
        nomeSolicitante='João Pedro',
        endereco='Rua da Lua, 77',
        referencia='Portão azul',
        tipoMaterial='Metal',
        pesoEstimado='10kg',
        detalhesAdicionais='Grades velhas.',
        observacoes='Precisa de ajuda para carregar.',
        collectionCode='20039',
        bairro='Cohab Massangano',
        status=CollectionStatus.available,
        latitude=-9.394,
        longitude=-40.514
    ),
    CollectionModel(
        tempoColeta='Hoje, 14:00 - 16:00',
        distanciaKm='1.1 km',
        nomeSolicitante='Kelly Freitas',
        endereco='Rua do Sol, 10',
        referencia='Perto da biblioteca',
        tipoMaterial='Papel',
        pesoEstimado='4kg',
        detalhesAdicionais='Papelão limpo.',
        observacoes='Ligar antes.',
        collectionCode='20040',
        bairro='Atrás da Banca',
        status=CollectionStatus.available,
        latitude=-9.391,
        longitude=-40.506
    ),
    CollectionModel(
        tempoColeta='Amanhã, 10:00 - 12:00',
        distanciaKm='3.1 km',
        nomeSolicitante='Leonardo Siqueira',
        endereco='Av. Principal, 200',
        referencia='Mercado Central',
        tipoMaterial='Eletrônicos',
        pesoEstimado='2kg',
        detalhesAdicionais='Rádio antigo.',
        observacoes='Não funciona.',
        collectionCode='20041',
        bairro='Areia Branca',
        status=CollectionStatus.available,
        latitude=-9.380,
        longitude=-40.516
    ),
    CollectionModel(
        tempoColeta='Segunda, 13:00 - 15:00',
        distanciaKm='5.5 km',
        nomeSolicitante='Monica Aragão',
        endereco='Rua da Estrela, 50',
        referencia='Casa rosa',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='3L',
        detalhesAdicionais='Óleo de fritura.',
        observacoes='Garrafas bem fechadas.',
        collectionCode='20042',
        bairro='Alto do Cocar',
        status=CollectionStatus.available,
        latitude=-9.375,
        longitude=-40.534
    ),
    CollectionModel(
        tempoColeta='Hoje, 16:00 - 18:00',
        distanciaKm='1.9 km',
        nomeSolicitante='Nathan Viana',
        endereco='Rua do Rio, 120',
        referencia='Perto da orla',
        tipoMaterial='Plástico',
        pesoEstimado='6kg',
        detalhesAdicionais='Garrafas PET.',
        observacoes='Pode levar o saco.',
        collectionCode='20043',
        bairro='Centro',
        status=CollectionStatus.available,
        latitude=-9.399,
        longitude=-40.500
    ),
    CollectionModel(
        tempoColeta='Amanhã, 08:00 - 10:00',
        distanciaKm='2.8 km',
        nomeSolicitante='Otavio Lins',
        endereco='Rua da Mata, 33',
        referencia='Árvore grande na frente',
        tipoMaterial='Vidro',
        pesoEstimado='2kg',
        detalhesAdicionais='Garrafas de vinho.',
        observacoes='Tocar campainha.',
        collectionCode='20044',
        bairro='Gercino Coelho',
        status=CollectionStatus.available,
        latitude=-9.405,
        longitude=-40.499
    ),
    CollectionModel(
        tempoColeta='Quinta, 14:00 - 16:00',
        distanciaKm='3.7 km',
        nomeSolicitante='Patricia Duarte',
        endereco='Rua do Campo, 80',
        referencia='Perto do estádio',
        tipoMaterial='Metal',
        pesoEstimado='15kg',
        detalhesAdicionais='Bicicleta velha desmontada.',
        observacoes='Ferrugem.',
        collectionCode='20045',
        bairro='José e Maria',
        status=CollectionStatus.available,
        latitude=-9.371,
        longitude=-40.506
    ),
    CollectionModel(
        tempoColeta='Sexta, 09:00 - 11:00',
        distanciaKm='4.6 km',
        nomeSolicitante='Quintino Bocaiuva',
        endereco='Rua da História, 1889',
        referencia='Museu',
        tipoMaterial='Papel',
        pesoEstimado='20kg',
        detalhesAdicionais='Documentos antigos para triturar.',
        observacoes='Sigiloso.',
        collectionCode='20046',
        bairro='Rio Corrente',
        status=CollectionStatus.available,
        latitude=-9.400,
        longitude=-40.514
    ),
    CollectionModel(
        tempoColeta='Hoje, 11:00 - 13:00',
        distanciaKm='1.5 km',
        nomeSolicitante='Renata Vasconcelos',
        endereco='Av. da Notícia, 20',
        referencia='Emissora de TV',
        tipoMaterial='Eletrônicos',
        pesoEstimado='5kg',
        detalhesAdicionais='Câmeras quebradas.',
        observacoes='Portaria 2.',
        collectionCode='20047',
        bairro='Vila Eduardo',
        status=CollectionStatus.available,
        latitude=-9.384,
        longitude=-40.489
    ),
    CollectionModel(
        tempoColeta='Amanhã, 15:00 - 17:00',
        distanciaKm='2.3 km',
        nomeSolicitante='Samuel Rosa',
        endereco='Rua da Música, 10',
        referencia='Estúdio',
        tipoMaterial='Óleo de Cozinha',
        pesoEstimado='10L',
        detalhesAdicionais='Óleo de restaurante.',
        observacoes='Galões grandes.',
        collectionCode='20048',
        bairro='Atrás da Banca',
        status=CollectionStatus.available,
        latitude=-9.392,
        longitude=-40.507
    ),
    CollectionModel(
        tempoColeta='Segunda, 08:00 - 10:00',
        distanciaKm='3.5 km',
        nomeSolicitante='Tatiana Amaral',
        endereco='Rua das Flores, 99',
        referencia='Jardim Botânico',
        tipoMaterial='Plástico',
        pesoEstimado='3kg',
        detalhesAdicionais='Vasos de planta de plástico.',
        observacoes='Quebrados.',
        collectionCode='20049',
        bairro='Cohab Massangano',
        status=CollectionStatus.available,
        latitude=-9.393,
        longitude=-40.518
    ),
    CollectionModel(
        tempoColeta='Hoje, 10:00 - 12:00',
        distanciaKm='4.9 km',
        nomeSolicitante='Ulisses Guimarães',
        endereco='Av. da Constituição, 1988',
        referencia='Praça dos Três Poderes',
        tipoMaterial='Vidro',
        pesoEstimado='1kg',
        detalhesAdicionais='Copo quebrado.',
        observacoes='Muito cuidado.',
        collectionCode='20050',
        bairro='Jardim Amazonas',
        status=CollectionStatus.available,
        latitude=-9.387,
        longitude=-40.529
    ),
]

db_notifications: List[NotificationModel] = []
db_chats: List[ChatMessageModel] = []

# --- Endpoints da API ---

@app.get("/")
def read_root():
    """Rota de verificação de saúde da API."""
    return {"message": "API Recicla Mais rodando", "docs": "/docs"}

# --- Endpoints de Coletas ---

@app.get("/collections", response_model=List[CollectionModel])
def get_collections(status: Optional[CollectionStatus] = None):
    """
    Retorna todas as coletas.
    Pode filtrar por status (ex: /collections?status=available).
    """
    if status:
        return [c for c in db_collections if c.status == status]
    return db_collections

@app.get("/collections/{code}", response_model=CollectionModel)
def get_collection_by_code(code: str):
    """Busca uma coleta específica pelo código."""
    for coleta in db_collections:
        if coleta.collectionCode == code:
            return coleta
    raise HTTPException(status_code=404, detail="Coleta não encontrada")

@app.post("/collections", response_model=CollectionModel)
def create_collection(coleta: CollectionModel):
    """Cria uma nova solicitação de coleta."""
    for c in db_collections:
        if c.collectionCode == coleta.collectionCode:
            raise HTTPException(status_code=400, detail="Código de coleta já existe")
    
    db_collections.append(coleta)
    return coleta

@app.delete("/collections/{code}")
def delete_collection(code: str):
    """Exclui uma coleta pelo código."""
    global db_collections
    initial_len = len(db_collections)
    db_collections = [c for c in db_collections if c.collectionCode != code]
    if len(db_collections) == initial_len:
        raise HTTPException(status_code=404, detail="Coleta não encontrada")
    return {"message": f"Coleta {code} excluída com sucesso"}

@app.patch("/collections/{code}/accept", response_model=CollectionModel)
def accept_collection(code: str):
    """Aceita uma coleta e cria uma notificação."""
    for i, coleta in enumerate(db_collections):
        if coleta.collectionCode == code:
            if coleta.status != CollectionStatus.available:
                raise HTTPException(status_code=400, detail="Esta coleta não está disponível para aceite.")
            
            updated_coleta = coleta.model_copy(update={"status": CollectionStatus.pending})
            db_collections[i] = updated_coleta
            
            # Criar notificação automática
            new_notif = NotificationModel(
                id=f"notif_{datetime.now().timestamp()}",
                userId="system", # Em um app real seria o ID do solicitante
                title="Coleta Aceita",
                message=f"Sua coleta {code} foi aceita por um coletor!",
                type=NotificationType.success
            )
            db_notifications.append(new_notif)
            
            return updated_coleta
            
    raise HTTPException(status_code=404, detail="Coleta não encontrada")

@app.patch("/collections/{code}/finalize", response_model=CollectionModel)
def finalize_collection(code: str):
    """Finaliza uma coleta e cria uma notificação."""
    for i, coleta in enumerate(db_collections):
        if coleta.collectionCode == code:
            if coleta.status != CollectionStatus.pending:
                raise HTTPException(status_code=400, detail="Apenas coletas pendentes podem ser finalizadas.")
            
            updated_coleta = coleta.model_copy(update={"status": CollectionStatus.completed})
            db_collections[i] = updated_coleta

            # Criar notificação automática
            new_notif = NotificationModel(
                id=f"notif_{datetime.now().timestamp()}",
                userId="system",
                title="Coleta Finalizada",
                message=f"A coleta {code} foi concluída com sucesso!",
                type=NotificationType.success
            )
            db_notifications.append(new_notif)

            return updated_coleta
            
    raise HTTPException(status_code=404, detail="Coleta não encontrada")

@app.patch("/collections/{code}/cancel", response_model=CollectionModel)
def cancel_collection(code: str):
    """Cancela uma coleta aceita."""
    for i, coleta in enumerate(db_collections):
        if coleta.collectionCode == code:
            if coleta.status == CollectionStatus.pending:
                updated_coleta = coleta.model_copy(update={"status": CollectionStatus.available})
                db_collections[i] = updated_coleta
                return updated_coleta
            else:
                raise HTTPException(status_code=400, detail="Não é possível cancelar esta coleta no status atual.")
            
    raise HTTPException(status_code=404, detail="Coleta não encontrada")

# --- Endpoints de Notificações ---

@app.get("/notifications/{user_id}", response_model=List[NotificationModel])
def get_notifications(user_id: str):
    """Lista notificações de um usuário."""
    # No mock, retornamos todas ou filtramos por userId se necessário
    return [n for n in db_notifications if n.userId == user_id or n.userId == "system"]

@app.post("/notifications", response_model=NotificationModel)
def create_notification(notification: NotificationModel):
    """Cria uma nova notificação manualmente."""
    db_notifications.append(notification)
    return notification

# --- Endpoints de Chat ---

@app.get("/chat/{user_id}", response_model=List[ChatMessageModel])
def get_chat_messages(user_id: str, collectionCode: Optional[str] = None):
    """Lista mensagens de chat, opcionalmente filtradas por código de coleta."""
    # Nota: user_id aqui é mantido por compatibilidade, mas o filtro principal agora é collectionCode
    messages = db_chats
    if collectionCode:
        messages = [m for m in messages if m.collectionCode == collectionCode]
    return messages

@app.post("/chat/{user_id}", response_model=ChatMessageModel)
def send_message(user_id: str, message: ChatMessageModel):
    """Envia uma mensagem de chat vinculada a uma coleta."""
    db_chats.append(message)
    return message

# --- Endpoints de Usuários ---

@app.get("/users", response_model=List[UserResponseModel])
def get_users(user_type: Optional[UserType] = None):
    """Lista todos os usuários, opcionalmente filtrados por tipo."""
    if user_type:
        return [u for u in db_usuarios if u.userType == user_type]
    return db_usuarios

@app.get("/users/{user_id}", response_model=UserResponseModel)
def get_user_by_id(user_id: str):
    """Busca um usuário específico pelo ID."""
    for user in db_usuarios:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

@app.post("/users/register", response_model=UserResponseModel)
def register_user(user: UserModel):
    """Registra um novo usuário."""
    for u in db_usuarios:
        if u.email == user.email:
            raise HTTPException(status_code=400, detail="E-mail já cadastrado")
    
    db_usuarios.append(user)
    return user

@app.post("/users/login", response_model=UserResponseModel)
def login_user(login_data: UserLoginModel):
    """Realiza o login do usuário."""
    for user in db_usuarios:
        if user.email == login_data.email and user.senha == login_data.senha:
            return user
    raise HTTPException(status_code=401, detail="Credenciais inválidas")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)