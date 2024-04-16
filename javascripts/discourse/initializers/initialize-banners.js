import { hbs } from "ember-cli-htmlbars";
import { withPluginApi } from "discourse/lib/plugin-api";
import { registerWidgetShim } from "discourse/widgets/render-glimmer";

export default {
  name: "initialize-banner-widget",
  initialize() {
    registerWidgetShim(
      "geo-banner-widget",
      "div.widget-connector",
      hbs`<Banner/>`
    );

    withPluginApi("0.1", (api) => {
      api.decorateWidget("post:after", (helper) => {
        if (helper.widget.model.post_number === 1) {
          return helper.attach("geo-banner-widget");
        }
      });
    });
  },
};
