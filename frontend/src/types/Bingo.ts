import type { BingoEntry } from "./BingoEntry";

export type Bingo = {
	name: string;
	fields: Array<BingoEntry>;
	size: number;
	freeCenter: boolean;
	freeAnywhere: boolean;
};
