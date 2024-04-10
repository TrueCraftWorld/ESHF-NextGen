#include "socket.h"
#include <QDebug>

enum eshfModes	{ NO_MODE = 0, BI_BLEND=1,
                            BI_TUR=2, BI_ARTRO=3, BI_GISTERO=4,
                            BI_COAG=5, BI_COAG_DISS=6, TERMOSHOV=7,
                            CUT=8, BLEND=9, BLEND1=10, TUR=11, VAP=12,
                            E_KNIFE1=13, E_KNIFE2=14, E_KNIFE3=15,
                            E_LOOP1=16, E_LOOP2=17, E_LOOP3=18,
                            FORCE=19, FULGUR=20, SOFT=21, SPRAY=22,
                            FULGUR_A=23, SPRAY_A=24,
                            FULGUR_P=25, SPRAY_P=26,
                            };
QStringList modesNames = { "NO MODE", "BI BLEND",
                           "BI TUR", "BI ARTRO", "BI GISTERO",
                           "BI COAG", "BI COAG DISSECT", "TERMOSHOV",
                           "CUT", "BLEND", "BLEND1", "TUR", "VAP",
                           "ENDO KNIFE1", "ENDO KNIFE2", "ENDO KNIFE3",
                           "ENDO LOOP1", "ENDO LOOP2", "ENDO LOOP3",
                           "FORCE", "FULGUR", "SOFT", "SPRAY",
                           "FULGUR ARGON", "SPRAY ARGON",
                           "FULGUR PULSE ARGON", "SPRAY PULSE ARGON",
                           };

QList<int> modesMaxPowers	{ 1, 75,
                            8, 8, 8,
                            150, 150, 5,
                            400, 400, 150, 400, 400,
                            27, 27, 27,
                            27, 27, 27,
                            150, 150, 300, 70,
                            150, 70,
                            70, 70,
                            };


SOCKET::SOCKET(SOCKET::SocType type, QObject *parent)
{
    Q_UNUSED(parent);

    m_socketStatus = S_ENABLED;
    m_cutModeIndex = 0;
    m_coagModeIndex = 0;
    m_socketType = type;
    generatingModeList(this);


    m_cutSound.setLoopCount(QSoundEffect::Infinite);
    m_cutSound.setSource(QUrl::fromLocalFile("/usr/share/qtpr/CUT_SOUND.wav"));
    m_coagSound.setLoopCount(QSoundEffect::Infinite);
    if (m_socketType > SOCKET::BIPOLAR_2) m_coagSound.setSource(QUrl::fromLocalFile("/usr/share/qtpr/MONO_COAG_SOUND.wav"));
    else m_coagSound.setSource(QUrl::fromLocalFile("/usr/share/qtpr/BI_COAG_SOUND.wav"));
    connect(this, &SOCKET::socketStatusChanged, this, &SOCKET::soundControl);

}


int SOCKET::coagModeIndex() const
{
    return m_coagModeIndex;
}

void SOCKET::setCoagModeIndex(int newCoagModeIndex)
{
    if ((m_coagModeIndex == newCoagModeIndex) ||
            (newCoagModeIndex >= coagModes.size()) ||
            (newCoagModeIndex < 0))
        return;
    m_coagModeIndex = newCoagModeIndex;
    emit coagModeIndexChanged();
    emit socketInfoUpdated(outputInfo(this, true));
}

int SOCKET::cutModeIndex() const
{
    return m_cutModeIndex;
}

void SOCKET::setcutModeIndex(int newCutModeIndex)
{
    if ((m_cutModeIndex == newCutModeIndex) ||
            (newCutModeIndex >= cutModes.size()) ||
            (newCutModeIndex < 0))
        return;
    m_cutModeIndex = newCutModeIndex;
    emit cutModeIndexChanged();
    emit socketInfoUpdated(outputInfo(this, false));
}

SOCKET::SocType SOCKET::socketType() const
{
    return m_socketType;
}

void SOCKET::setSocketType(SOCKET::SocType newSocketType)
{
    if (m_socketType == newSocketType)
        return;
    cutModes.clear();
    coagModes.clear();
    m_socketType = newSocketType;
    generatingModeList(this);
    emit socketTypeChanged();
}

EshfMode::EshfMode(QObject *parent)
{
    Q_UNUSED(parent);
}

EshfMode::EshfMode(QString name, int maximum, bool isCoag, QObject *parent)
{
        Q_UNUSED(parent);
    m_modeName = name;
    m_maximumPower = maximum;
    m_currentPower = 1;
    m_isCoag = isCoag;
}

int EshfMode::currentPower() const
{
    return m_currentPower;
}

void EshfMode::setCurrentPower(int newCurrentPower)
{
    if (m_currentPower == newCurrentPower)
        return;
    m_currentPower = newCurrentPower;
    emit currentPowerChanged();
}

int EshfMode::maximumPower() const
{
    return m_maximumPower;
}

void EshfMode::setMaximumPower(int newMaximumPower)
{
    if (m_maximumPower == newMaximumPower)
        return;
    m_maximumPower = newMaximumPower;
    emit maximumPowerChanged();
}

const QString &EshfMode::modeName() const
{
    return m_modeName;
}

void EshfMode::setModeName(const QString &newModeName)
{
    if (m_modeName == newModeName)
        return;
    m_modeName = newModeName;
    emit modeNameChanged();
}

SOCKET::SocStatus SOCKET::socketStatus() const
{
    return m_socketStatus;
}

void SOCKET::setSocketStatus(SocStatus newSocketStatus)
{
    if (m_socketStatus == newSocketStatus)
        return;
    m_socketStatus = newSocketStatus;
    emit socketStatusChanged();
}

const QString &SOCKET::socketName() const
{
    return m_socketName;
}

void SOCKET::setSocketName(const QString &newSocketName)
{
    if (m_socketName == newSocketName)
        return;
    m_socketName = newSocketName;
    emit socketNameChanged();
}

EshfMode *SOCKET::getCoagMode(int index)
{
    if (coagModes.length() >= index) return coagModes[index];
    
    return nullptr;
}

EshfMode *SOCKET::getCutMode(int index)
{
    if (cutModes.length() >= index) return cutModes[index];
 
    return nullptr;
}

void SOCKET::cutPowerChange()
{
    emit socketInfoUpdated(outputInfo(this, false));
}
void SOCKET::coagPowerChange()
{
    emit socketInfoUpdated(outputInfo(this, true));
}

void SOCKET::generatingModeList(SOCKET* socket)
{
    int coagStart = 0;
    int cutStart = 0;
    int coagStop = 0;
    int cutStop = 0;
    switch (socket->socketType()) {
    case SocType::EMPTY:
        m_socketName = QString("EMPTY");
        cutStart = 0;  cutStop = 0;
        coagStart = 0;   coagStop = 0;
        break;
    case SocType::BIPOLAR_1:
        m_socketName = QString("BIPOLAR 1");
        cutStart = 1;  cutStop = 4+1;
        coagStart = 5;   coagStop = 6+1;
        break;
    case SocType::BIPOLAR_2:
        m_socketName = QString("BIPOLAR 2");
        cutStart = 1;  cutStop = 4+1;
        coagStart = 5;   coagStop = 7+1;
        break;
    case SocType::MONOPOLAR_1:
        m_socketName = QString("MONOPOLAR 1");
        cutStart = 8;   cutStop = 18+1;
        coagStart = 19;   coagStop = 26+1;
        break;
    case SocType::MONOPOLAR_2:
        m_socketName = QString("MONOPOLAR 2");
        cutStart = 8;  cutStop = 18+1;
        coagStart = 19;   coagStop = 22+1;
        break;
    }
    cutModes.append(new EshfMode(modesNames[0], modesMaxPowers[0], false, this));
    coagModes.append(new EshfMode(modesNames[0], modesMaxPowers[0],true, this));
    QQmlEngine::setObjectOwnership(cutModes.last(), QQmlEngine::CppOwnership);
    QQmlEngine::setObjectOwnership(coagModes.last(), QQmlEngine::CppOwnership);

    for (int i = cutStart; i < cutStop; ++i) {
        cutModes.append(new EshfMode(modesNames[i], modesMaxPowers[i], false, this));
        QQmlEngine::setObjectOwnership(cutModes.last(), QQmlEngine::CppOwnership);
        connect(cutModes.last(), &EshfMode::currentPowerChanged, this, &SOCKET::cutPowerChange);
    }
    for (int i = coagStart; i < coagStop; ++i) {
        coagModes.append(new EshfMode(modesNames[i], modesMaxPowers[i], true, this));
        QQmlEngine::setObjectOwnership(coagModes.last(), QQmlEngine::CppOwnership);
        connect(coagModes.last(), &EshfMode::currentPowerChanged, this, &SOCKET::coagPowerChange);
    }
}

QByteArray SOCKET::outputInfo(SOCKET *changedSocket, bool isCoag)
{
    QByteArray message;
    int outNum = ((static_cast<int>(changedSocket->socketType()))*2 - (isCoag ? 0 : 1));
    int modeNum;
    EshfMode *changedMode;
    int power;

    if (isCoag) changedMode = changedSocket->getCoagMode(changedSocket->coagModeIndex());
    else changedMode = changedSocket->getCutMode(changedSocket->cutModeIndex());
    modeNum = modesNames.indexOf(changedMode->modeName());
    power = changedMode->currentPower();

    QString outputInfo = QString("O%1 %2 %3     \n").arg(outNum).arg(modeNum).arg(power);
//    qDebug() << outputInfo;
    return message.append(outputInfo.toLatin1());
}

void SOCKET::soundControl()
{
    if (m_socketStatus == SOCKET::S_ACTIVE_COAG) {
        if (!m_coagSound.isPlaying()) m_coagSound.play();
    } else if (m_socketStatus == SOCKET::S_ACTIVE_CUT) {
        if (!m_cutSound.isPlaying()) m_cutSound.play();
    } else {
        if (m_coagSound.isPlaying()) m_coagSound.stop();
        if (m_cutSound.isPlaying()) m_cutSound.stop();
    }

}

