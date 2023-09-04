# IBM-Cloud-VPC-VSI-Backup
Esta guía provee información sobre el funcionamiento y la instalación de un agente de Veeam para IBM AIX

Veeam Agent para IBM AIX es una solución de protección de datos y recuperación ante desastres para equipos que ejecutan el sistema operativo IBM AIX.
Veeam Agent para IBM AIX puede ser utilizado por los administradores de TI que ejecutan infraestructuras IBM AIX. La solución se ejecuta dentro del sistema operativo de la máquina IBM AIX y puede instalarse en el sistema de archivos raíz de la máquina IBM AIX (LPAR).
Veeam Agent para IBM AIX le permite realizar copias de seguridad de directorios y archivos de su máquina IBM AIX. Las copias de seguridad pueden almacenarse en un disco duro local, en un disco duro externo, en una carpeta compartida en red o en un repositorio de copias de seguridad de Veeam.
En caso de desastre, puede restaurar los datos necesarios de las copias de seguridad a su ubicación original o a una nueva ubicación.
Veeam Agent para IBM AIX se integra con Veeam Backup & Replication. Los administradores de copias de seguridad que trabajan con Veeam Backup & Replication pueden realizar tareas avanzadas con Veeam Agent para copias de seguridad de IBM AIX: restaurar datos desde copias de seguridad, realizar tareas con trabajos de copia de seguridad configurados en Veeam Agent para IBM AIX y copias de seguridad creadas con estos jobs.

## Como funciona un backup
Durante la copia de seguridad, Veeam Agent para IBM AIX realiza las siguientes operaciones:
1. Veeam Agent for IBM AIX crea un archivo de copia de seguridad en la ubicación de destino. 
2. En el archivo de copia de seguridad, Veeam Agent para IBM AIX crea un disco virtual. El disco contiene un volumen con el sistema de archivos 
sistema de archivos ext4.
3. Veeam Agent for IBM AIX lee los datos seleccionados para la copia de seguridad, los comprime y los copia en la ubicación de destino. Como parte del proceso de copia de seguridad de archivos, Veeam Agent realiza los siguientes pasos:
a. Para cada archivo incluido en la copia de seguridad, crea un archivo de destino en el volumen dentro del archivo de copia de seguridad.
b. Abre los archivos de origen y de destino.
c. Lee los datos del archivo de origen y los transfiere al archivo de destino.
d. Cierra los archivos de origen y destino.
[Para la copia de seguridad incremental] Para detectar los archivos que han cambiado en el equipo de Veeam Agent desde la sesión de copia de seguridad anterior sesión de backup, Veeam Agent lee los metadatos de los archivos y compara la última hora de modificación de los archivos en la ubicación original y los archivos de la copia de seguridad. Durante la copia de seguridad incremental, Veeam Agent copia sólo los archivos nuevos o modificados en la ubicación de destino. Para obtener más información sobre la copia de seguridad completa e incremental, consulte Cadena de copias de seguridad.
Veeam Agent para IBM AIX bloquea los archivos copiados durante el proceso de copia de seguridad. Sin embargo, Veeam Agent no realiza un seguimiento de si los datos respaldados cambian en la ubicación original desde el momento en que se inició el proceso de copia de seguridad. Por ejemplo, si aparece un archivo nuevo en un directorio incluido en la copia de seguridad después de que se inicie el proceso de copia de seguridad, Veeam Agent no copiará este archivo en el destino Para asegurarse de que los datos de la copia de seguridad están en el estado consistente se recomienda no realizar operaciones de escritura en el sistema de archivos que contiene los datos de la copia de seguridad hasta que finalice el proceso de copia de seguridad.

# Instalación y configuración:
## Consideraciones previas: 
Antes de iniciar el proceso de instalación, compruebe los siguientes requisitos previos:
1. El equipo en el que tiene previsto instalar Veeam Agent para IBM AIX debe cumplir los requisitos del sistema.
2. Para instalar y ejecutar Veeam Agent para IBM AIX, debe utilizar la cuenta raíz o cualquier cuenta de usuario que tenga privilegios de superusuario (raíz) en el equipo en el que tiene previsto instalar el producto.
3. La instalación de Veeam Agent para IBM AIX requiere el paquete rpm.rte versión 3.0.5.20 o posterior. Este gestor de paquetes se suministra con el sistema operativo IBM AIX a partir de la versión 6.1. Para asegurarse de que el conjunto de archivos rpm.rte del equipo en el que desea instalar Veeam Agent no falta o no está obsoleto, haga lo siguiente:
a. Compruebe la versión del conjunto de archivos rpm.rte con el comando lslpp -l rpm.rte. Utilice la información de esta página web para comprobar que la versión del conjunto de archivos rpm.rte instalado es compatible con la versión del sistema operativo del equipo.
b. Si el conjunto de archivos rpm.rte instalado está desactualizado o no está instalado, puede descargar un conjunto de archivos rpm.rte que cumpla con los requisitos desde esta página web.
4. Asegúrese de que /opt, /var, /usr, /etc y otros sistemas de archivos tienen suficiente espacio libre para instalar el producto. Si es necesario, utilice la herramienta chfs para aumentar el tamaño del sistema de archivos.
5. Si tiene previsto activar la indexación del sistema de archivos en la configuración del trabajo de copia de seguridad, deberá instalar la utilidad mlocate en el equipo Veeam Agent. La utilidad se proporciona junto con Veeam Agent en los medios de instalación del producto.
6. Si tiene previsto crear Veeam Recovery Media, debe tener el comando mkisofs funcional en el equipo Veeam Agent.
7. Puede instalar y utilizar Veeam Agent para IBM AIX en un LPAR o WPAR

## Instalar software como prerequisito:
Si desea habilitar la indexación del sistema de archivos en la configuración de la tarea de copia de seguridad, debe instalar la utilidad mlocate en el equipo Veeam Agent. La utilidad se proporciona junto con Veeam Agent en los medios de instalación del producto. Para instalar la utilidad mlocate
1. Obtenga el archivo de instalación de Veeam Agent para IBM AIX.
2. Extraiga el contenido del archivo de instalación a un directorio accesible desde el equipo en el que desee instalar el producto. Por ejemplo, puede ser un directorio del sistema de archivos local o un directorio NFS. 
3. Navegue hasta el directorio en el que extrajo el archivo con el comando cd y, a continuación, utilice el comando:

`rpm -ivh mlocate-0.26-1.aix6.1.ppc.rpm`

## Instalar el agente: 
Puede instalar Veeam Agent para IBM AIX mediante el gestor de paquetes RPM. Para instalar Veeam Agent para IBM AIX:
1. Descargue el archivo de instalación de Veeam Agent para IBM AIX desde la [página de descargas de Veeam](https://www.veeam.com/ibm-aix-agent-download.html). 
2. 2. Extraiga el contenido del archivo de instalación a un directorio al que pueda acceder desde el equipo 
en el que desee instalar el producto. Por ejemplo, puede ser un directorio del sistema de archivos local o un directorio NFS. 
directorio NFS.
3. Navegue hasta el directorio en el que extrajo el archivo con el comando cd y, a continuación, utilice el comando 
siguiente comando:

