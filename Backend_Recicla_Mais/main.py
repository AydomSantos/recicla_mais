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
    #teste
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

@app.get("/users", response_model=List[UserModel])
def get_users(user_type: Optional[UserType] = None):
    """Lista todos os usuários, opcionalmente filtrados por tipo."""
    if user_type:
        return [u for u in db_usuarios if u.userType == user_type]
    return db_usuarios

@app.get("/users/{user_id}", response_model=UserModel)
def get_user_by_id(user_id: str):
    """Busca um usuário específico pelo ID."""
    for user in db_usuarios:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="Usuário não encontrado")

@app.post("/users/register", response_model=UserModel)
def register_user(user: UserModel):
    """Registra um novo usuário."""
    for u in db_usuarios:
        if u.email == user.email:
            raise HTTPException(status_code=400, detail="E-mail já cadastrado")
    
    db_usuarios.append(user)
    return user

@app.post("/users/login", response_model=UserModel)
def login_user(login_data: UserLoginModel):
    """Realiza o login do usuário."""
    for user in db_usuarios:
        if user.email == login_data.email and user.senha == login_data.senha:
            return user
    raise HTTPException(status_code=401, detail="Credenciais inválidas")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)