Trix = require("trix")
{lang} = Trix.config

Trix.config.toolbar =
	getDefaultHTML: -> """
		<div class="trix-button-row">
		<span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
		<button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="#{lang.bold}" tabindex="-1">加粗</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="#{lang.strike}" tabindex="-1">删除线</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="#{lang.link}" tabindex="-1">链接</button>
		</span>
		<span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
		<button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="#{lang.heading1}" tabindex="-1">标题一</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="#{lang.quote}" tabindex="-1">引用</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="#{lang.code}" tabindex="-1">代码</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="#{lang.bullets}" tabindex="-1">无序</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="#{lang.numbers}" tabindex="-1">有充</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="#{lang.outdent}" tabindex="-1">右缩进</button>
		<button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="#{lang.indent}" tabindex="-1">左缩进</button>
		</span>
		<span class="trix-button-group-spacer"></span>
		<span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
    <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="x-insert-image" tabindex="-1"></button>
		</span>
		</div>

		<div class="trix-dialogs" data-trix-dialogs>

		<div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
		<div class="trix-dialog__link-fields">
		<input type="url" name="href" class="trix-input trix-input--dialog" placeholder="#{lang.urlPlaceholder}" aria-label="#{lang.url}" required data-trix-input>
		</div>
		</div>

		</div>
		"""
