import nodeResolve from "@rollup/plugin-node-resolve";
import typescript from "@rollup/plugin-typescript";
import commonjs from "@rollup/plugin-commonjs";
import path from "node:path";
import url from "node:url";

const isWatch = !!process.env.ROLLUP_WATCH;
const sdPlugin = "com.ih4xz.langbutton.sdPlugin";

/**
 * @type {import("rollup").RollupOptions}
 */
const config = {
	input: "src/plugin.ts",
	output: {
		file: `${sdPlugin}/bin/plugin.js`,
		format: "esm",
		sourcemap: isWatch,
		sourcemapPathTransform: (relativeSourcePath, sourcemapPath) => {
			return url.pathToFileURL(path.resolve(path.dirname(sourcemapPath), relativeSourcePath)).href;
		}
	},
	// Only externalize true Node.js built-ins — everything else must be bundled
	external: [/^node:/],
	plugins: [
		{
			name: "watch-externals",
			buildStart: function () {
				this.addWatchFile(`${sdPlugin}/manifest.json`);
			}
		},
		// commonjs MUST come before nodeResolve to handle CJS packages like ws
		commonjs({
			ignoreDynamicRequires: true
		}),
		nodeResolve({
			exportConditions: ["node"],
			preferBuiltins: true
		}),
		typescript()
	]
};

export default config;
