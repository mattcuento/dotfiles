return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          -- Your JDTLS configuration goes here
          jdtls = {
             settings = {
               java = {
                 configuration = {
                   runtimes = {
                     {
                       name = "JavaSE-23",
                       path = "/Users/mcuento/.asdf/installs/java/openjdk-21.0.2",
                     },
                   },
                 },
               },
             },
          },
        },
        setup = {
          jdtls = function()
            -- Your nvim-java configuration goes here
            require("java").setup({
               root_markers = {
                 "settings.gradle",
                 "settings.gradle.kts",
                 "pom.xml",
                 "build.gradle",
                 "mvnw",
                 "gradlew",
                 "build.gradle",
                 "build.gradle.kts",
               },
            })
          end,
        },
      },
    },
  },
}
