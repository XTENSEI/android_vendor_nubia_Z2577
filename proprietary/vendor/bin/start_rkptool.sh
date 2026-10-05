#!/vendor/bin/sh
/vendor/bin/rkp_factory_extraction_tool --output_format build+csr > /mnt/vendor/csr.json
chmod 664 /mnt/vendor/csr.json