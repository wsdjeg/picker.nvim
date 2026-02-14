# Changelog

## [1.8.0](https://github.com/wsdjeg/picker.nvim/compare/v1.7.0...v1.8.0) (2026-02-14)


### Features

* picker custom layouts ([ed133eb](https://github.com/wsdjeg/picker.nvim/commit/ed133eb3d7e806674eabb04747d7cf5beae145ab))


### Bug Fixes

* check buf and win is valid ([0466fd4](https://github.com/wsdjeg/picker.nvim/commit/0466fd4ec149d1eed2c8a646fef0b007f9b93965))
* massively improve annotations, optimized code portions ([#16](https://github.com/wsdjeg/picker.nvim/issues/16)) ([470a98c](https://github.com/wsdjeg/picker.nvim/commit/470a98cbffb549d8b1086e00672b17caaabeecd5))

## [1.7.0](https://github.com/wsdjeg/picker.nvim/compare/v1.6.0...v1.7.0) (2026-01-24)


### Features

* add async_files redraw_actions ([ad053d6](https://github.com/wsdjeg/picker.nvim/commit/ad053d6096c54f7b58afb83ffa3799dd860ed380))
* add levenshtein matcher ([f90d6f0](https://github.com/wsdjeg/picker.nvim/commit/f90d6f02c1529488822f183632fc488e943116b4))
* add lsp_declarations source ([ade8756](https://github.com/wsdjeg/picker.nvim/commit/ade8756e09bc9141820b3debd58e5a63568c83b3))
* add lsp_definitions source ([7d50f4f](https://github.com/wsdjeg/picker.nvim/commit/7d50f4fdcde0edfd7c763703d1d2a232e33cb349))
* add lsp_implementations source ([3428b19](https://github.com/wsdjeg/picker.nvim/commit/3428b197b36f1ccb609d7dcc2e6b9299e76f0941))
* add lsp_type_definitions source ([bd17e89](https://github.com/wsdjeg/picker.nvim/commit/bd17e89121fe464a4e8e421da4c80a13fdda6b3f))
* add redraw_actions ([b5dd418](https://github.com/wsdjeg/picker.nvim/commit/b5dd418ad2fb5a3a8616861387c67f5bd602abfa))
* add search_history source ([4d2b31f](https://github.com/wsdjeg/picker.nvim/commit/4d2b31fecf29ace6dfdf7656102ad408ab1fbf54))
* add tags source ([11fffdb](https://github.com/wsdjeg/picker.nvim/commit/11fffdb23d5aafb7bd7a49c76c6b2f16837e12da))
* **buffers:** add ctrl-v/t actions ([df2d668](https://github.com/wsdjeg/picker.nvim/commit/df2d668bfcc6983775ea651e493f9fb3188f1ab4))
* **buffers:** highlight directory as Comment ([5f38279](https://github.com/wsdjeg/picker.nvim/commit/5f3827909fb42a452fc716882ba5c2c900aa75a4))
* support built-in matchfuzzy matcher ([bf684b4](https://github.com/wsdjeg/picker.nvim/commit/bf684b465730247dc5fbc39a4e6030ae1f59d5c1))


### Bug Fixes

* add editorconfig file ([eb59f2c](https://github.com/wsdjeg/picker.nvim/commit/eb59f2ce47f4587fec47c2705ac3c12ec29eb298))
* complete `--input=` for Picker command ([9e55d12](https://github.com/wsdjeg/picker.nvim/commit/9e55d12bf699cd06c9777a22c243d70f077833d9))
* fix definition cursor position ([83faecc](https://github.com/wsdjeg/picker.nvim/commit/83faecc04693e355760394c2695ea0f19cd5ecd8))
* remove debug log ([3006588](https://github.com/wsdjeg/picker.nvim/commit/300658824c090d59546b764daaa991924b451c05))
* remove match test ([36a868f](https://github.com/wsdjeg/picker.nvim/commit/36a868f27a0527109fe23338a2e6d0349379b27d))
* **types:** move all [@class](https://github.com/class) into types.lua ([e0a4d3f](https://github.com/wsdjeg/picker.nvim/commit/e0a4d3fad80abfd1708dead5a6f3a6ecd726ee42))
* update async_files cmd ([75c83ed](https://github.com/wsdjeg/picker.nvim/commit/75c83edba5e9ec7980e0cb3a5156401d5247108a))
* use bufnr instead of str when preview buffer ([2e2a177](https://github.com/wsdjeg/picker.nvim/commit/2e2a1774ddcf403e246916d0b1aaa4c891fa8e63))
* use default matcher if failed ([fc2fb76](https://github.com/wsdjeg/picker.nvim/commit/fc2fb7664485b29515d0844934f04bc2b1b0885f))

## [1.6.0](https://github.com/wsdjeg/picker.nvim/compare/v1.5.0...v1.6.0) (2025-11-29)


### Features

* add cmd previewer ([189730e](https://github.com/wsdjeg/picker.nvim/commit/189730e6f64911cd967664b47274979f46c1c49a))


### Bug Fixes

* fix cmd previewer ([dac5bc8](https://github.com/wsdjeg/picker.nvim/commit/dac5bc87abff26ede02168638ba871be1df6a143))
* format help file ([90fa1d2](https://github.com/wsdjeg/picker.nvim/commit/90fa1d2340432cffeb7e5a2ba324dbbb14eb4323))
* use unix fileformat ([b7dc3a8](https://github.com/wsdjeg/picker.nvim/commit/b7dc3a8eda4a8678860c24aa96ba0da5ac3c66d6))

## [1.5.0](https://github.com/wsdjeg/picker.nvim/compare/v1.4.0...v1.5.0) (2025-11-22)


### Features

* add devicons support for async_files ([649b4bd](https://github.com/wsdjeg/picker.nvim/commit/649b4bd302d214ff50a677ae159e7837bc95cbf0))
* add devicons support for buffer source ([61764ce](https://github.com/wsdjeg/picker.nvim/commit/61764ce4989c1ace819889ce76a8e7a9e76e46ae))
* add luarocks support ([831f117](https://github.com/wsdjeg/picker.nvim/commit/831f117029eff2e602015f059d88722a73f79214))
* make files support devicon ([745a220](https://github.com/wsdjeg/picker.nvim/commit/745a22072d944cf86918fa60a5d886b4aa8ae955))


### Bug Fixes

* check filter_items nil ([a42589a](https://github.com/wsdjeg/picker.nvim/commit/a42589ae4f7f144b715d7e78282c1a4d5f712ac1))
* clear filter_items on startup ([852a39c](https://github.com/wsdjeg/picker.nvim/commit/852a39c04d2c4e3bb1bb3755fef85795848295ff))
* fix register source ([9f11821](https://github.com/wsdjeg/picker.nvim/commit/9f11821d69f6f7f89bdc191acc26daa92e4d1722))
* keep scrolloff default to 0 ([096a249](https://github.com/wsdjeg/picker.nvim/commit/096a249caf89edcd4dd5c827a12a6ba61c8c8f81))
* remove stderr and argv ([1756ceb](https://github.com/wsdjeg/picker.nvim/commit/1756ceb8e914b681d3740f3f48fb0a2e3cce9102))
* use full path instead ([ae53103](https://github.com/wsdjeg/picker.nvim/commit/ae531034d986a9a1ad66df516ee3f96af1551d7a))

## [1.4.0](https://github.com/wsdjeg/picker.nvim/compare/v1.3.0...v1.4.0) (2025-11-09)


### Features

* add `key-mappings` source ([18b7c2e](https://github.com/wsdjeg/picker.nvim/commit/18b7c2e7e64f494b828d74f38e5becb6d6604ebb))


### Bug Fixes

* fix key-mappings preview file ([9765fe3](https://github.com/wsdjeg/picker.nvim/commit/9765fe3beca12fab56912267e423dfc7a863a4dc))
* fix windows height ([fc60c6c](https://github.com/wsdjeg/picker.nvim/commit/fc60c6c50ec7288a1c77b5cd1c9daa644c7afb01))
* include buffer local key mappings ([c0b4659](https://github.com/wsdjeg/picker.nvim/commit/c0b4659ea8e1d744c6cb1b0be7dcfaa53fb4f42e))

## [1.3.0](https://github.com/wsdjeg/picker.nvim/compare/v1.2.0...v1.3.0) (2025-11-02)


### Features

* add `ignorecase` option ([569d57a](https://github.com/wsdjeg/picker.nvim/commit/569d57a5cb60d12160cf749027ac5e4df0903372))
* add `picker_config` source ([d7658ee](https://github.com/wsdjeg/picker.nvim/commit/d7658ee3bbb78943c1c83c9f0a4e1d788e6ff00e))
* add async_files source ([#8](https://github.com/wsdjeg/picker.nvim/issues/8)) ([9a45081](https://github.com/wsdjeg/picker.nvim/commit/9a450813ae54b6af8ee704da6925ca1abaad53a4))
* add cmd_history source ([12102f0](https://github.com/wsdjeg/picker.nvim/commit/12102f0be6ea1ca03240caf6905d199eed6f72c3))
* add ctrl-v/t actions for files ([1f58fd7](https://github.com/wsdjeg/picker.nvim/commit/1f58fd715aa64c1688203432926a0bfd112f4fc9))
* add emoji source ([4b758c5](https://github.com/wsdjeg/picker.nvim/commit/4b758c501bce7e572bf3b05789b8716e0b022f57))
* add highlights source ([13bfd86](https://github.com/wsdjeg/picker.nvim/commit/13bfd86346d76a526bcfb2fdfc139974fb95d4e1))
* add loclist ([a70bc6c](https://github.com/wsdjeg/picker.nvim/commit/a70bc6c5d1ecb8e3e4ac8e603c3b2a303518722f))
* add lsp kind icons ([d40ee9a](https://github.com/wsdjeg/picker.nvim/commit/d40ee9af3d004d015ea5eace0946926566a6de2b))
* add lsp_document_symbols source ([76333ec](https://github.com/wsdjeg/picker.nvim/commit/76333ecd8fd7d9700904ffd844f7603e2bddca0a))
* add lsp_references source ([0d401f0](https://github.com/wsdjeg/picker.nvim/commit/0d401f07e7357bc1965ebe834e171383fd777508))
* add lsp_workspace_symbols source ([5a49b17](https://github.com/wsdjeg/picker.nvim/commit/5a49b17ad172d4885d88a1d6ba19e8536a715e41))
* add opt to change list_files_cmd ([3ccd2eb](https://github.com/wsdjeg/picker.nvim/commit/3ccd2eb0c2643aefdaa7a63b6cc8a3893a78f30c))
* add option for displaying source name ([4dbd190](https://github.com/wsdjeg/picker.nvim/commit/4dbd1908f54f8aa6ae3ce0ba5624869440fc92ad))
* add option to display matched score ([3e51ddd](https://github.com/wsdjeg/picker.nvim/commit/3e51ddd76f09f88aa6e34b3453274b2245345a7f))
* add prompt filetype to disable cmp ([7ca2e74](https://github.com/wsdjeg/picker.nvim/commit/7ca2e7471dab9372109f93c0ad347f5a8d32845c))
* implement filter state ([95e0ece](https://github.com/wsdjeg/picker.nvim/commit/95e0ece274afb62d80460a814d6c0d096d2f57c4))
* support custom layout ([d970367](https://github.com/wsdjeg/picker.nvim/commit/d970367e4a4f93afb14197b23e0750a784e374d8))
* support force update context ([525295d](https://github.com/wsdjeg/picker.nvim/commit/525295d0321b6273a53787db3ed7c9242dad4420))
* support insert_timeout feature ([58088ec](https://github.com/wsdjeg/picker.nvim/commit/58088eca2d52cb796d2544cdcb8a5f958142dbee))


### Bug Fixes

* avoid getting length of nil ([6427dfe](https://github.com/wsdjeg/picker.nvim/commit/6427dfeb93d68d3e0109b0b05d2ccf2fd603a18c))
* disable ctrl-j in insert mode ([1cdb6bf](https://github.com/wsdjeg/picker.nvim/commit/1cdb6bfe2b7fd69ed1df55e32a47caf8929bdb21))
* disable F1-F12 in promot windows ([30701f4](https://github.com/wsdjeg/picker.nvim/commit/30701f44066619e012cde6d125977563dd9bbcd1))
* display newline and enable number ([0a0066c](https://github.com/wsdjeg/picker.nvim/commit/0a0066c8c78a05e5412b16e16af9cb4caba11c03))
* fix bottom prompt source name ([fa3e660](https://github.com/wsdjeg/picker.nvim/commit/fa3e660e70e1fea93bf7d2d3b6ad76fb27af1796))
* fix default_action ([7f05cff](https://github.com/wsdjeg/picker.nvim/commit/7f05cff08620ec051cff680a333c05d58670ab9b))
* fix winhighlight opt ([ea8bb13](https://github.com/wsdjeg/picker.nvim/commit/ea8bb137ef81e80489cbd748b0fa316f15c27b73))
* handle layout error ([01657e9](https://github.com/wsdjeg/picker.nvim/commit/01657e9c784d1feab69510c33fb6d1023d3b3cd7))
* skip action on nil ([12b7b1a](https://github.com/wsdjeg/picker.nvim/commit/12b7b1a31b055258a752cb2747f4f9c5c852b1b6))
* skip highlight if filter_items is nil ([a9b2220](https://github.com/wsdjeg/picker.nvim/commit/a9b222077095fb15b6f1282d62c07e87de41a10d))
* sort filter_items only when input ~= nil ([e6f58ad](https://github.com/wsdjeg/picker.nvim/commit/e6f58adb42f6d677150ed8c1c16dcb3b0ae1f52d))
* trigger TextChangedI only in same job ([a4d0370](https://github.com/wsdjeg/picker.nvim/commit/a4d037098ead433a49bd88eb1c87c076ef6babb9))
* use `job.nvim` instead of vim.system ([4501676](https://github.com/wsdjeg/picker.nvim/commit/450167625384f5d2d05d0a9dbd6f263835b57f36))
* use empty string for unloaded buf ([ce115d7](https://github.com/wsdjeg/picker.nvim/commit/ce115d724ee0eb9e27f5f0da3fce7bfb68ff8607))
* use handle func instead of doautocmd ([55b49cb](https://github.com/wsdjeg/picker.nvim/commit/55b49cb43e75f4d179d2d67a1522940bd38ec850))

## [1.2.0](https://github.com/wsdjeg/picker.nvim/compare/v1.1.0...v1.2.0) (2025-10-19)


### Features

* add `jumps` source ([efc1770](https://github.com/wsdjeg/picker.nvim/commit/efc1770c9ac9fdc38c43cae2ddaef9681a18d08a))
* add `lines` source ([8e35736](https://github.com/wsdjeg/picker.nvim/commit/8e35736771af35abb0c7e0550c2168b7ff6464cf))
* add `marks` source ([c9e0aab](https://github.com/wsdjeg/picker.nvim/commit/c9e0aab9f102ae36fbd7576e1c8965abb5f71c9e))
* add help_tags source ([5aa6aab](https://github.com/wsdjeg/picker.nvim/commit/5aa6aabcd4affb1f73920cdc156912dcbb5ecfa4))
* add PickerItem.highlight ([b90c922](https://github.com/wsdjeg/picker.nvim/commit/b90c9223bc72912188f45767a48e6899be8f0ae2))
* add qflist source ([5ed603d](https://github.com/wsdjeg/picker.nvim/commit/5ed603dd91b0477bba7d0a77a01d603bf571f2c2))
* add registers source ([545f6eb](https://github.com/wsdjeg/picker.nvim/commit/545f6eb0aeffd9bb981e08578d311151eee0c3ec))
* display context in jumps ([081c903](https://github.com/wsdjeg/picker.nvim/commit/081c9034cd064dd80ed43e77b20788301b335f42))
* enable preview for buffers source ([83599fd](https://github.com/wsdjeg/picker.nvim/commit/83599fd5b143d53b3bb48dd578550f3df0f4e2e0))
* enable preview of registers source ([8841e71](https://github.com/wsdjeg/picker.nvim/commit/8841e718c8710ba6d83184568d6dff36f3c519ee))
* support `<cword>` input ([7b7dc4d](https://github.com/wsdjeg/picker.nvim/commit/7b7dc4d398b43b1af38949b3b30663b9188f76ca))
* support multiple actions ([6442cd5](https://github.com/wsdjeg/picker.nvim/commit/6442cd5e9263d8f1265429612de068843121529c))
* support preview_file pattern ([322512c](https://github.com/wsdjeg/picker.nvim/commit/322512cd83949c5466d48ffc90a5dd3e9b9f8e4a))


### Bug Fixes

* check win_is_valid before set win opt ([9e3f232](https://github.com/wsdjeg/picker.nvim/commit/9e3f232b48a1af8c6114b353caba293565f0b0d0))
* clear preview buf before preview ([cc67fb8](https://github.com/wsdjeg/picker.nvim/commit/cc67fb8aafc72b8665d4d6491f72e7b5b5eb1648))
* disable content for jumps ([7e370a6](https://github.com/wsdjeg/picker.nvim/commit/7e370a6b1d44ba3cc2dc21765fe38f866c597621))
* fix default_action of register source ([b0ffd07](https://github.com/wsdjeg/picker.nvim/commit/b0ffd0731169cf8e493546ba456b3400e1cd7fd4))
* fix highlight col ([1b52577](https://github.com/wsdjeg/picker.nvim/commit/1b5257740b6fcc7ee4377e35b521b95c33e36af4))
* fix jump source action ([7fe98e3](https://github.com/wsdjeg/picker.nvim/commit/7fe98e3e7dde817b20504f0ab5d0b67cc3ae05a5))
* fix missing files ([04478c8](https://github.com/wsdjeg/picker.nvim/commit/04478c84886dd3ab98c7c24c27b80474c719303f))
* jumps source only display readable file ([7b75631](https://github.com/wsdjeg/picker.nvim/commit/7b756313aebf00de1bf80a6412954123df4ff0d3))
* make sure preview_bufnr is valid ([03b753a](https://github.com/wsdjeg/picker.nvim/commit/03b753ac1777e9641702a6a8ae3154cc3f438fcc))
* remove filereadable check ([334b43b](https://github.com/wsdjeg/picker.nvim/commit/334b43be03ba81b27c2d012a5ab41ea337b51671))
* set preview_buf bufhidden to wipe ([f20e849](https://github.com/wsdjeg/picker.nvim/commit/f20e84912f3ab99e92e4e75ed473460bdc5789c7))
* skip duplicate getreg func ([e9e418c](https://github.com/wsdjeg/picker.nvim/commit/e9e418c0faae274eb2972ae579ce8f68bb930073))
* skip empty bufname ([7aec34f](https://github.com/wsdjeg/picker.nvim/commit/7aec34f82876a2e20cbdf9f41cbe19e448e1d470))
* update highlight after toggle_preview ([36b0e6c](https://github.com/wsdjeg/picker.nvim/commit/36b0e6c81a758d29d2103731ab92f5fd2218e41b))

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
