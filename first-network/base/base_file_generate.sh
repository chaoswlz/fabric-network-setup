#!/bin/bash
PEERNUM="$1"
ORGNUM="$2"

echo "# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

version: '2'

services:

  orderer.example.com:
    container_name: orderer.example.com
    image: hyperledger/fabric-orderer
    environment:
      - ORDERER_GENERAL_LOGLEVEL=debug
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    volumes:
    - ../channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
    - ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp:/var/hyperledger/orderer/msp
    - ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/:/var/hyperledger/orderer/tls
    ports:
      - 7050:7050

  peer$PEERNUM.org$ORGNUM.example.com:
    container_name: peer$PEERNUM.org$ORGNUM.example.com
    extends:
      file: peer-base.yaml
      service: peer-base
    environment:
      - CORE_PEER_ID=peer$PEERNUM.org$ORGNUM.example.com
      - CORE_PEER_ADDRESS=peer$PEERNUM.org$ORGNUM.example.com:7051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer$PEERNUM.org$ORGNUM.example.com:7051
      - CORE_PEER_LOCALMSPID=Org"$ORGNUM"MSP
    volumes:
        - /var/run/:/host/var/run/
        - ../crypto-config/peerOrganizations/org$ORGNUM.example.com/peers/peer$PEERNUM.org$ORGNUM.example.com/msp:/etc/hyperledger/fabric/msp
        - ../crypto-config/peerOrganizations/org$ORGNUM.example.com/peers/peer$PEERNUM.org$ORGNUM.example.com/tls:/etc/hyperledger/fabric/tls
    ports:
      - 7051:7051
      - 7053:7053
" >&docker-compose-base.yaml