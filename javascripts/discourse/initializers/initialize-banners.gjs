import { withPluginApi } from "discourse/lib/plugin-api";
import Banner from "../components/banner";

const PLUGIN_API_VERSION = "1.44.0";

function registerBanner(api) {
  api.renderAfterWrapperOutlet("post-article", Banner);
}

export default {
  name: "initialize-geo-banner",
  initialize() {
    withPluginApi(PLUGIN_API_VERSION, (api) => registerBanner(api));
  },
};
