# Changelog

## [1.1.0](https://github.com/wsdjeg/picker.nvim/compare/v1.0.0...v1.1.0) (2025-10-11)


### Features

* add ctags-outline picker ([#5](https://github.com/wsdjeg/picker.nvim/issues/5)) ([41b4c53](https://github.com/wsdjeg/picker.nvim/commit/41b4c53ac6cdae832d67d2d74d348f4a91da63ec))
* add current_icon & highlight ([74dee88](https://github.com/wsdjeg/picker.nvim/commit/74dee88f5d4ef8bc266248cad9b0b0e8a0ec6f6c))
* add linenr to file previewer ([e82804a](https://github.com/wsdjeg/picker.nvim/commit/e82804a7e6956044a90317fc177541074789f691))
* add preview windows ([#4](https://github.com/wsdjeg/picker.nvim/issues/4)) ([3ea1c18](https://github.com/wsdjeg/picker.nvim/commit/3ea1c1818fbb0eca928f46565b8760678d1e6b08))
* add source menu ([b42b955](https://github.com/wsdjeg/picker.nvim/commit/b42b955f48dedcc188b0678013057d56ddd43e3c))
* enable preview for buftags source ([0737ec8](https://github.com/wsdjeg/picker.nvim/commit/0737ec8ce63f77a3990c39c37147b78e9be3edec))
* support `--input` opt ([054e4fe](https://github.com/wsdjeg/picker.nvim/commit/054e4fea3eef64198ccd9ab4ef9a58cf8d57a3e7))


### Bug Fixes

* check filter_rst length before index ([2a6e683](https://github.com/wsdjeg/picker.nvim/commit/2a6e6838298e6ff387e0ae73037f9ad13d98898b))
* disable ctrl-c in prompt buffer ([3ec90ce](https://github.com/wsdjeg/picker.nvim/commit/3ec90ce64c2186ea38780ca411de28f069b42b69))
* fix icon background ([5e03f3f](https://github.com/wsdjeg/picker.nvim/commit/5e03f3fd4a2a3408726556085872ed925afb3296))
* fix index nil in windows.open ([6289f49](https://github.com/wsdjeg/picker.nvim/commit/6289f493dab075f209f74790d375768c6e570ba6))
* hide Search highlight ([a3d6fb2](https://github.com/wsdjeg/picker.nvim/commit/a3d6fb2229a5394270bbb664cd8364d6cfabdff9))
* update preview win opt ([bc832fb](https://github.com/wsdjeg/picker.nvim/commit/bc832fb97a8092a56ed885c30b9a4220c18c6dfb))
* use `Tag` as default matched hl ([98f8aae](https://github.com/wsdjeg/picker.nvim/commit/98f8aaebdcdd2f8154cb22c98c70caf527a2e7d5))
* use libuv.fs_read instead ([6085530](https://github.com/wsdjeg/picker.nvim/commit/6085530bdb3f55df67668c3cc4e74a2c31f9a35c))
* wrap startinsert command ([60847b5](https://github.com/wsdjeg/picker.nvim/commit/60847b5254b68f34873b2bfe33612fff4af9c38b))

## 1.0.0 (2025-10-08)


### Features

* add buffers source ([0cbe011](https://github.com/wsdjeg/picker.nvim/commit/0cbe0115a97d720e4a94d8fd154c051073807ba9))
* add mru source for mru.nvim ([1e8a9c2](https://github.com/wsdjeg/picker.nvim/commit/1e8a9c2257d89ecdb6ea64d554c00b9f9a29c4e1))
* add result counter ([346b928](https://github.com/wsdjeg/picker.nvim/commit/346b928d93a6ea189c989f60456dccc590a096f1))
* support custom mappings ([428d87c](https://github.com/wsdjeg/picker.nvim/commit/428d87cdc167a526d63358f2a18d4b518e851aa5))
* support custom prompt icon and highlight ([a715c9e](https://github.com/wsdjeg/picker.nvim/commit/a715c9efc82b5786e341047aa772dbd265d8488b))


### Bug Fixes

* change windows opt of list win ([ef3e6de](https://github.com/wsdjeg/picker.nvim/commit/ef3e6de2d8a92cfb80a7a3cc0af1b440e2a12d99))
* check filter_rst length ([baf4cbd](https://github.com/wsdjeg/picker.nvim/commit/baf4cbd987a388b3d21e57c9711fec19905ac910))
* clear filter_rst ([e9eef20](https://github.com/wsdjeg/picker.nvim/commit/e9eef20bdc6fd166af9dfe1f8bd960f0e2919a56))
* fix index nil ([28cb6b5](https://github.com/wsdjeg/picker.nvim/commit/28cb6b585551282559fa01acdb2733288d00879b))
* handle unknown source ([4915327](https://github.com/wsdjeg/picker.nvim/commit/4915327d84085ca32f28d664643672dba03cbde0))
* move cursor to first line when input changed ([69c4387](https://github.com/wsdjeg/picker.nvim/commit/69c438788528531c9edd91ea1aef97f0af9a3371))
* update highlight chars after moving cursor ([3e4fbf5](https://github.com/wsdjeg/picker.nvim/commit/3e4fbf5b4c85e959ccc4192a5ae5c86284c00ae8))
