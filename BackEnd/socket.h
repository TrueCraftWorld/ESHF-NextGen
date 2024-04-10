#ifndef SOCKET_H
#define SOCKET_H

#include <QObject>
#include <QString>
#include <QList>
#include <QStringList>
#include <QQmlContext>
#include <QQmlEngine>
#include <QSoundEffect>



class EshfMode : public QObject{
    Q_OBJECT
    Q_PROPERTY(int currentPower READ currentPower WRITE setCurrentPower NOTIFY currentPowerChanged)
    Q_PROPERTY(int maximumPower READ maximumPower WRITE setMaximumPower NOTIFY maximumPowerChanged)
    Q_PROPERTY(QString modeName READ modeName WRITE setModeName NOTIFY modeNameChanged)



public:

    explicit EshfMode(QObject *parent = nullptr);
    EshfMode(QString, int, bool, QObject *parent = nullptr);

    void setCurrentPower(int newCurrentPower);
    void setMaximumPower(int newMaximumPower);
    void setModeName(const QString &newModeName);

    int maximumPower() const;
    int currentPower() const;
     const QString &modeName() const;

private:

     int m_currentPower;
     int m_maximumPower;
     QString m_modeName;
     bool m_isCoag;

signals:
    void currentPowerChanged();
    void maximumPowerChanged();
    void modeNameChanged();
};


class SOCKET : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString socketName READ socketName WRITE setSocketName NOTIFY socketNameChanged)
    Q_PROPERTY(int coagModeIndex READ coagModeIndex WRITE setCoagModeIndex NOTIFY coagModeIndexChanged)
    Q_PROPERTY(int cutModeIndex READ cutModeIndex WRITE setcutModeIndex NOTIFY cutModeIndexChanged)
    Q_PROPERTY(SocType socketType READ socketType WRITE setSocketType NOTIFY socketTypeChanged)
    Q_PROPERTY(SocStatus socketStatus READ socketStatus WRITE setSocketStatus NOTIFY socketStatusChanged)


public:
    enum SocType {  EMPTY,
                    BIPOLAR_1,
                    BIPOLAR_2,
                    MONOPOLAR_1,
                    MONOPOLAR_2
                        };
    Q_ENUM( SocType )
    enum SocStatus {S_OFF,
                    S_ENABLED,
                    S_ACTIVE_COAG,
                    S_ACTIVE_CUT
                        };
    Q_ENUM( SocStatus )

    SOCKET(SOCKET::SocType = EMPTY, QObject *parent = nullptr);

    int coagModeIndex() const;
    int cutModeIndex() const;
    SocType socketType() const;
    SocStatus socketStatus() const;
    const QString &socketName() const;

    void setCoagModeIndex(int newCoagModeIndex);    
    void setcutModeIndex(int newCutModeIndex);    
    void setSocketType(SOCKET::SocType newSocketType);
    void setSocketStatus(SocStatus newSocketStatus);
    void setSocketName(const QString &newSocketName);

    Q_INVOKABLE EshfMode* getCoagMode(int index);
    Q_INVOKABLE EshfMode* getCutMode(int index);
private:

    int m_coagModeIndex;

    int m_cutModeIndex;

    SocType m_socketType;

    QList< EshfMode*> cutModes;
    QList< EshfMode*> coagModes;

    SocStatus m_socketStatus;

    QString m_socketName;
    void generatingModeList(SOCKET *socket);
    QByteArray outputInfo(SOCKET *changedSocket, bool isCoag);
    QSoundEffect m_coagSound;
    QSoundEffect m_cutSound;
public slots:
    void soundControl();
signals:
    void socketInfoUpdated(const QByteArray &data);
    void coagModeIndexChanged();
    void cutModeIndexChanged();
    void socketTypeChanged();
    void socketStatusChanged();
    void socketNameChanged();
public slots:
    void cutPowerChange();
    void coagPowerChange();

//    void pedChanged();
};

#endif // SOCKET_H
