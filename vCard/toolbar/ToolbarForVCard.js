const dialogTrigger = pass;

mw.loader.using( '@wikimedia/codex' ).then( function( require ) {
	const Vue = require( 'vue' );
	const Codex = require( '@wikimedia/codex' );
	const mountPoint = document.body.appendChild( document.createElement( 'div' ) );
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
                if ( value ) {
                    menuItems.value = types.filter( ( item ) =>
                        item.label.includes( value )
                    );
                }
            }
		},
		mounted() {
			dialogTrigger.addEventListener( 'click', this.openDialog );
		},
		unMounted() {
			dialogTrigger.removeEventListener( this.openDialog );
		}
	}).component( 'cdx-lookup', Codex.CdxLookup )
	.component( 'cdx-dialog', Codex.CdxDialog )
	.mount( mountPoint );
});