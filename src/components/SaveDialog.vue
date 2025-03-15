<template>
	<v-dialog v-model="model" max-width="500">
		<v-card>
			<v-card-title class="pa-0">
				<v-toolbar class="pl-4" density="compact">
					<span>
						Share [<span> {{ props.data.name }} </span>]
					</span>
					<v-spacer />
					<v-btn
						icon="mdi-close"
						rounded="0"
						class="mr-0"
						@click="() => (model = false)"
					/>
				</v-toolbar>
			</v-card-title>
			<v-card-text>
				<v-text-field
					:value="text"
					readonly
					density="compact"
					hide-details
					class="pr-0"
					append-inner-icon="mdi-content-copy"
					@click:append-inner="copyText"
					@focus="$event.target.select()"
				/>
			</v-card-text>
		</v-card>
	</v-dialog>
	<v-snackbar v-model="showSnackbar" color="primary">
		<div class="text-center">Copied link</div>
	</v-snackbar>
</template>
<script lang="ts" setup>
import type { Bingo } from "@/types/Bingo";

const route = useRoute();
const model = defineModel<boolean>();
const props = defineProps({
	data: {
		type: Object as PropType<Bingo>,
		required: true,
	},
});

const showSnackbar = ref(false);

const text = computed(() => {
	return window.location.href;
});

const copyText = () => {
	window.navigator.clipboard.writeText(text.value);
	showSnackbar.value = true;
};

window.console.error(model, props.data);
</script>
<style scoped></style>
