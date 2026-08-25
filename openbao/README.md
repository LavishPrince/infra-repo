# Access the container's shell and initialize OpenBao
docker exec -it openbao bao operator init


# Run this command for Key 1, Key 2, and Key 3
docker exec -it openbao bao operator unseal
