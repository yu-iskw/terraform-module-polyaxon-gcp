.PHONY: default
default: format generate-docs

#
# target(s) to format files
#
.PHONY: format
format:
	terraform fmt -recursive

#
# targets to generate documents
#
.PHONY: generate-docs generate-docs-inputs generate-docs-outputs generate-docs-sub-modules
generate-docs: generate-docs-inputs generate-docs-outputs generate-docs-sub-modules

# Generate document about module inputs
generate-docs-inputs:
	terraform-docs markdown table \
		--no-outputs \
		--no-providers \
		--no-requirements \
		--sort-inputs-by-required \
	    . > docs/inputs.md

# Generate document about module outputs
generate-docs-outputs:
	terraform-docs markdown table \
		--no-inputs \
		--no-providers \
		--no-requirements \
		. > docs/outputs.md

# Generate documents of sub-modules
generate-docs-sub-modules: generate-docs-cpu-node-pool-module generate-docs-gpu-node-pool-module

# Generate document of sub-module: cpu_experiments_node_pool
generate-docs-cpu-node-pool-module:
	$(eval MODULE_PATH = "./modules/cpu_experiments_node_pool")
	terraform-docs markdown table \
		--no-header \
		--no-providers \
		--no-requirements \
		--sort-inputs-by-required \
		"$(MODULE_PATH)" > "$(MODULE_PATH)"/inputs_and_outputs.md

# Generate document of sub-module: gpu_experiments_node_pool
generate-docs-gpu-node-pool-module:
	$(eval MODULE_PATH = "./modules/gpu_experiments_node_pool")
	terraform-docs markdown table \
		--no-header \
		--no-providers \
		--no-requirements \
		--sort-inputs-by-required \
		"$(MODULE_PATH)" > "$(MODULE_PATH)"/inputs_and_outputs.md
