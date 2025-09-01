return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		config = function()
			local jdtls = require("jdtls")

			local home = os.getenv("HOME")
			local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

			local config = {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar",
					"-configuration",
					jdtls_path .. "/config_linux",
					"-data",
					workspace_dir,
				},
				root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			}

			jdtls.start_or_attach(config)
		end,
	},
}
