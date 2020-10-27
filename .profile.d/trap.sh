#!/bin/bash

trap cleanup EXIT
cleanup() {
  trap 'exit 0' EXIT
  echo exiting
}

cleanup
