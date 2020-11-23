mkdir -p /config/cloud
mkdir -p /var/log/cloud/azure
curl https://raw.githubusercontent.com/cavalen/aolab-azure/master/deploy-tf/bigip-runtime-init-install-only.yaml -o /config/cloud/runtime-init-conf.yaml
curl -L https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.0.0/dist/f5-bigip-runtime-init-1.0.0-1.gz.run -o f5-bigip-runtime-init-1.0.0-1.gz.run && bash f5-bigip-runtime-init-1.0.0-1.gz.run -- '--cloud azure" 2>&1
f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml 2>&1
