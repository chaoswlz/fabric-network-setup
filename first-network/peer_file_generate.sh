#!/bin/bash
ORDERERIP="$1"
PEERNUM="$2"
ORGNUM="$3"
LOCALIP="$4"

echo "# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

version: '2'

networks:
  byfn:

services:

  peer$PEERNUM.org$ORGNUM.example.com:
    container_name: peer$PEERNUM.org$ORGNUM.example.com
    extends:
      file:  base/docker-compose-base.yaml
      service: peer$PEERNUM.org$ORGNUM.example.com
    networks:
      - byfn
    extra_hosts:
      - \"orderer.example.com:$ORDERERIP\"

  cli:
    container_name: cli
    image: hyperledger/fabric-tools
    tty: true
    environment:
      - GOPATH=/opt/gopath
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_LOGGING_LEVEL=DEBUG
      - CORE_PEER_ID=cli
      - CORE_PEER_ADDRESS=peer$PEERNUM.org$ORGNUM.example.com:7051
      - CORE_PEER_LOCALMSPID=Org"$ORGNUM"MSP
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org$ORGNUM.example.com/peers/peer$PEERNUM.org$ORGNUM.example.com/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org$ORGNUM.example.com/peers/peer$PEERNUM.org$ORGNUM.example.com/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org$ORGNUM.example.com/peers/peer$PEERNUM.org$ORGNUM.example.com/tls/ca.crt
      - CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org$ORGNUM.example.com/users/Admin@org$ORGNUM.example.com/msp
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    volumes:
        - ./peer:/opt/gopath/src/github.com/hyperledger/fabric/peer/
        - /var/run/:/host/var/run/
        - ./../chaincode/:/opt/gopath/src/github.com/chaincode
        - ./crypto-config:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/
        - ./scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/
        - ./channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts
    depends_on:
      - peer$PEERNUM.org$ORGNUM.example.com
    networks:
      - byfn
    extra_hosts:
      - \"orderer.example.com:$ORDERERIP\"
      - \"peer$PEERNUM.org$ORGNUM.example.com:$LOCALIP\"
" >&docker-compose-peer.yaml