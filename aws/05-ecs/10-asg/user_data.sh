#!/bin/bash
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_clster}
ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
EOF
