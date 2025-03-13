import type { BingoEntry } from "./BingoEntry";

export type Bingo = {
	name: string;
	seed: string;
	fields: Array<BingoEntry>;
	size: number;
};
