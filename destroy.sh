#!/usr/bin/env bash

# so the variable one will not prompt
export TF_VAR_from_prompt=""

# destroy all
for d in example_*/ ; do
	if [ -d "${d}/.terraform" ]; then
		printf "Destroying ${d}\n"
		pushd ${d}
		terraform destroy -force
		popd
    fi
done