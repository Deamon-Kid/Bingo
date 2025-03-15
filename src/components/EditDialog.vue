<template>
	<v-dialog
		v-model="model"
		:fullscreen="display.smAndDown.value"
		scrollable
		transition="dialog-top-transition"
	>
		<v-card>
			<v-card-title class="pa-0">
				<v-toolbar density="compact">
					<v-spacer />
					<v-text-field
						hideDetails
						singleLine
						label="Bingo Name"
						v-model="data.name"
						density="compact"
					>
						<template #append>
							<v-select
								v-model="data.size"
								:items="[3, 5]"
								label="Size"
								hide-details
								density="compact"
								max-width="100px"
								width="100px"
							/>
						</template>
					</v-text-field>
					<v-spacer />
					<v-btn icon @click="model = false" rounded="0" class="mr-0">
						<v-icon>mdi-content-save</v-icon>
					</v-btn>
				</v-toolbar>
			</v-card-title>
			<v-card-text>
				<v-alert v-if="!valid" type="warning">
					You need at least {{ data.size * data.size }} fields
					{{ data.fields.length }}
				</v-alert>
				<v-data-table
					:items="data.fields"
					:headers="headers"
					hide-default-footer
					dense
					fixed-header
					items-per-page="-1"
				>
					<template #[`item.value`]="{ item }">
						<v-text-field
							v-model="item.value"
							hide-details
							placeholder="Insert Field"
							single-line
						/>
					</template>
					<template #[`item.free`]="{ item }">
						<v-switch
							v-model="item.free"
							hide-details
							color="primary"
						/>
					</template>
					<template #[`item.actions`]="{ index }">
						<v-btn
							variant="text"
							color="error"
							@click="data.fields.splice(index, 1)"
						>
							<v-icon size="x-large">mdi-delete</v-icon>
						</v-btn>
					</template>
					<template #[`body.prepend`]>
						<tr>
							<td
								class="v-data-table__td v-data-table-column--align-start"
							>
								<v-text-field
									v-model="newItem.value"
									single-line
									hide-details
									placeholder="new Field"
									@keydown.enter="addEntry"
								/>
							</td>
							<td
								class="v-data-table__td v-data-table-column--align-start"
							>
								<v-switch
									v-model="newItem.free"
									density="compact"
									hide-details
									color="primary"
								/>
							</td>
							<td
								class="v-data-table__td v-data-table-column--align-start"
							>
								<v-btn
									color="success"
									variant="text"
									@click="addEntry"
								>
									<v-icon size="x-large">mdi-plus</v-icon>
								</v-btn>
							</td>
						</tr>
					</template>
				</v-data-table>
			</v-card-text>
		</v-card>
	</v-dialog>
</template>
<script lang="ts" setup>
import type { Bingo } from "@/types/Bingo";
import { useDisplay } from "vuetify";
// import BingoEntry from "./BingoEntry.vue";
const model = defineModel<boolean>();
const dataModel = defineModel("data", {
	type: Object as PropType<Bingo>,
	required: true,
});
const display = useDisplay();
const data = ref(dataModel);
const headers = [
	{ title: "Field", key: "value" },
	{ title: "Free", key: "free", width: "60px" },
	{ title: "Actions", key: "actions", width: "80px" },
];

const newItem = ref({ value: "", free: false });

watch(
	data,
	() => {
		dataModel.value = data.value;
	},
	{ deep: true }
);

const valid = computed(() => {
	const locked = data.value.fields.filter((f) => !f.free);
	const squareSize = data.value.size * data.value.size;
	return (
		locked.length >= squareSize ||
		(locked.length == squareSize - 1 &&
			data.value.fields.some((f) => f.free))
	);
});

const addEntry = () => {
	if (newItem.value.value === "") return;
	data.value.fields.push(newItem.value);
	newItem.value = { value: "", free: false };
};
</script>
<style scoped>
:deep(.v-data-table table tr td:first-child) {
	padding: 0 !important;
}
</style>
