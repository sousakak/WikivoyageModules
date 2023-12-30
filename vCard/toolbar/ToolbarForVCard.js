mw.loader.using( '@wikimedia/codex' ).then( function( require ) {
    const Vue = require( 'vue' );
	const Codex = require( '@wikimedia/codex' );
	const mountPoint = document.body;

    var see = function() {
        return {
            dialogs: {
                see: {
                    titleMsg: "タイプを選択",
                    id: 'wikieditor-toolbar-vCardTypes-dialog',
                    class: 'voy-vCardTypes voy-dialog voy-vCardTypes-see',
                    html: '<div class="voy-toolbar-vCardTypes-container"></div>',
                    init: function(){},
                    dialog: {
                        resizable: false,
                        dialogClass: 'wikiEditor-toolbar-dialog',
                        width: 590,
                        buttons: [
                            {
                                text: "決定",
                                click: function() {
                                    $( this ).dialog( 'close' );
                                    $.wikiEditor.modules.toolbar.fn.doAction(
                                        $( this ).data( 'context' ),
                                        {
                                            type: 'encapsulate',
                                            options: {
                                                pre: "{{vCard | type=" + "\n| name=",
                                                post: '',                    // !!! HERE !!!
                                                ownline: true
                                            }
                                        },
                                        $( this )
                                    );
                                }
                            },
                            {
                                text: "キャンセル",
                                click: function() {
                                    $( this ).dialog( 'close' );
                                }
                            }
                        ],
                        open: function() {
                            pass
                        }
                    }
                }
            }
        }
    }


    mw.hook( 'wikiEditor.toolbarReady' ).add( function ( $textarea ) {
        $textarea.wikiEditor( 'addModule', vCardTypes());
        $textarea.wikiEditor( 'addToToolbar', {
            sections: {
                listings: {
                    type: 'toolbar',
                    label: リスト
                }
            }
        });
        $textarea.wikiEditor( 'addToToolbar', {
            section: 'listings',
            groups: {
                templates: {
                    label: リスティング
                }
            }
        });
        window.setTimeout(changeToolbar, 500);
    });

    const types = {
        see: [
            {
                label: "",
                description: "",
                value: ""
            }
        ]
    }
	
	Vue.createMwApp({
		data: function() {
			return {
				showDialog: false,
                selection: Vue.ref( null ),
		        menuItems: Vue.ref( [] )
			};
		},
		template: `
			<cdx-dialog v-model:open="showDialog"
                :primary-action="primaryAction"
				hideTitle=true
				close-button-label="Close"
                :primary-action="primaryAction"
				:default-action="defaultAction"
				@default="open = false"
			>
                <cdx-lookup
                    v-model:selected="selection"
                    :menu-items="menuItems"
                    :menu-config="menuConfig"
                    aria-label="vCard types"
                    @input="onInput"
                />
			</cdx-dialog>
		`,
		methods: {
			openDialog () {
				this.showDialog = true;
			},
			increment() {
				this.count++;
			},
			decrement() {
				this.count--;
			},
            onInput( value ) {
                if ( !value ) {
                    menuItems.value = [];
                    return;
                }
                if ( value ) {
                    menuItems.value = types.filter( ( item ) =>
                        item.label.includes( value )
                    );
                }
            }
		},
	}).component( 'cdx-lookup', Codex.CdxLookup )
	.component( 'cdx-dialog', Codex.CdxDialog )
	.mount( mountPoint );
});