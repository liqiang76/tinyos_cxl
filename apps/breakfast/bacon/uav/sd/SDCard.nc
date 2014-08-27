/**
 * SdIO
 * sert � l'exploitation de la carte sd
 * @author Gwenha�l GOAVEC-MEROU
 */

interface SDCard {
   
	/**
   	* Commande pour l'�criture d'une chaine
   	* 
   	* @param addr : adresse de d�but d'�criture
   	* @param buf tableau � envoyer
   	* @param count longueur du tableau
   	* 
   	* @return SUCCESS Si l'�criture a fonctionn�e
   			FAIL sinon
   	*/
  	command error_t write(uint32_t addr, uint8_t*buf, uint16_t count);
    event void writeDone(uint32_t addr, uint8_t*buf, uint16_t count, error_t error);

  	/**
   	* Commande de lecture d'une chaine
   	* 
   	* @param addr : position de d�but de lecture
   	* @param buf : tableau dans lequel mettre l'information
   	* @param count longueur du tableau
   	* 
   	* @return SUCCESS Si la lecture est bonne
  	 		FAIL dans le cas contraire
   	*/
  	command error_t read(uint32_t addr, uint8_t*buf, uint16_t count);
    event void readDone(uint32_t addr, uint8_t*buf, uint16_t count, error_t error);

  	/**
   	* Commande pour la demande de lecture d'une chaine
   	* 
   	* @param addr : position de d�but de lecture
   	* @param buf : tableau dans lequel mettre l'information
   	* @param count longueur du tableau
   	* 
   	* @return SUCCESS Si la commande est accept�e
   	*/
  	//command error_t getSize();

  	/**
   	* Signal la fin de la lecture
   	*
   	* @param result SUCCESS si l'envoie n'a pas eut de probl�mes
   	* @param addr position de d�but de la lecture
   	* @param buf le tableau qui contient la chaine
   	* @param count la taille
   	*/
  	//event void getSizeDone(error_t result, uint32_t size);
 	
	/**
	* Remise � 0 de nbSector
	* 
	* @param offset : adresse de d�but du premier secteur � vider
	* @param nbSector : nombre de secteur � vider
	*
	* @return SUCCESS Si la suppression a r�ussie
			FAIL Autrement
  	*/
	command error_t clearSectors(uint32_t offset, uint16_t nbSectors);


  command uint8_t checkBusy(void);

  // Read the Card Size from the CSD Register
  command uint32_t readCardSize(void);
}
