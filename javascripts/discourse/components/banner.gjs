import Component from "@ember/component";
import { concat, fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import loadScript from "discourse/lib/load-script";
import i18n from "discourse-common/helpers/i18n";
import discourseComputed from "discourse-common/utils/decorators";

export default class Banner extends Component {
  tl = null;

  @action
  async setup() {
    try {
      await loadScript(settings.tweenMaxURL);

      const { TimelineMax, Power3, Back } = window;

      this.tl = new TimelineMax({
        repeat: 2,
        repeatDelay: 0,
        paused: true,
        onComplete: this.stopFrame.bind(this),
      });

      this.tl
        .from(
          ["#sp-footer", "#sp-bgblue"],
          0.5,
          { x: "+=728", ease: Power3.easeInOut },
          "-=0.0"
        )
        .from(
          "#sp-slide1",
          0.5,
          { y: "+=300", ease: Power3.easeInOut },
          "+=0.00"
        )
        .from(
          "#sp-btn",
          0.5,
          { scale: 0.8, alpha: 0, ease: Back.easeOut },
          "+=0.00"
        )
        .addLabel("stopFrame")
        .to("#sp-slide1", 0.5, { y: "-=300", ease: Power3.easeInOut }, "+=1.75")
        .from(
          "#sp-slide2",
          0.5,
          { y: "+=300", ease: Power3.easeInOut },
          "-=0.50"
        )
        .to(
          "#sp-logo",
          0.25,
          { alpha: 0, scale: 0.84, ease: Back.easeIn },
          "+=0.25"
        )
        .from(
          "#sp-slogan",
          0.25,
          { alpha: 0, scale: 0.84, ease: Back.easeOut },
          "-=0.00"
        )
        .to("#sp-slide2", 0.5, { y: "-=300", ease: Power3.easeInOut }, "+=1.00")
        .from(
          "#sp-slide3",
          0.5,
          { y: "+=300", ease: Power3.easeInOut },
          "-=0.50"
        )
        .to(
          "#sp-slogan",
          0.25,
          { alpha: 0, scale: 0.84, ease: Back.easeIn },
          "+=1.00"
        )
        .to(
          "#sp-logo",
          0.25,
          { alpha: 1, scale: 1, ease: Back.easeOut },
          "-=0.00"
        )
        .to("#sp-slide3", 0.5, { y: "-=300", ease: Power3.easeInOut }, "+=0.25")
        .to(
          ["#sp-bgblue", "#sp-btn", "#sp-footer"],
          0.5,
          { x: "+=728", ease: Power3.easeInOut },
          "-=0.00"
        );

      this.startFrame();
    } catch (error) {}
  }

  get logoLocation() {
    const logo =
      this.currentUser.geo_location.country_code === "CA"
        ? settings.theme_uploads.logo_ca
        : settings.theme_uploads.logo;

    return logo;
  }

  get sloganOne() {
    const slogan =
      this.currentUser.geo_location.country_code === "CA"
        ? i18n(themePrefix("slogan_ca.one"))
        : i18n(themePrefix("slogan_us.one"));

    return slogan;
  }
  get sloganTwo() {
    const slogan =
      this.currentUser.geo_location.country_code === "CA"
        ? i18n(themePrefix("slogan_ca.two"))
        : i18n(themePrefix("slogan_us.two"));

    return slogan;
  }

  teardown() {
    this.stopFrame();
  }

  startFrame() {
    this.tl?.play();
  }

  stopFrame() {
    this.tl?.seek("stopFrame");
    this.tl?.pause();
  }

  get urlDestination() {
    return "https://bananas.com";
  }

  @action
  gotoURL(currentUser) {
    const url =
      this.currentUser.geo_location.country_code === "CA"
        ? settings.tagURLca
        : settings.tagURLusa;

    window.open(url, "_blank");
  }

  <template>
    <div
      class="space-banner"
      {{didInsert this.setup}}
      {{willDestroy this.teardown}}
      {{on "click" (fn this.gotoURL this.currentUser)}}
    >
      <div class="sp-pos" id="sp-banner">
        <div class="sp-pos sp-blue" id="sp-bgblue"></div>

        <div class="sp-pos sp-slide" id="sp-slide2">
          <div class="sp-pos sp-shead" id="sp-shead2">{{i18n
              (themePrefix "slide.two")
            }}</div>
          <div class="sp-pos sp-simg" id="sp-simg2"></div>
        </div>

        <div class="sp-pos sp-slide" id="sp-slide1">
          <div class="sp-pos sp-shead" id="sp-shead1">{{i18n
              (themePrefix "slide.one")
            }}</div>
          <div class="sp-pos sp-simg" id="sp-simg1"></div>
        </div>

        <div class="sp-pos sp-slide" id="sp-slide3">
          <div class="sp-pos sp-shead" id="sp-shead3">{{i18n
              (themePrefix "slide.three")
            }}</div>
          <div class="sp-pos sp-simg" id="sp-simg3"></div>
        </div>

        <div class="sp-pos sp-red" id="sp-footer">
          <div class="sp-pos" id="sp-shipping">{{i18n
              (themePrefix "footer")
            }}</div>
        </div>

        <div class="sp-pos" id="sp-btn">{{i18n (themePrefix "button")}}</div>
        <div class="sp-pos" id="sp-slogan">
          <span class="sp-red1">{{this.sloganOne}}</span>
          <span class="sp-dark">{{this.sloganTwo}}</span>
        </div>

        {{log "dude." this.logoLocation}}
        <img src={{this.logoLocation}} alt="" class="sp-pos" id="sp-logo" />

        <div class="sp-pos" id="sp-frame"></div>
      </div>
    </div>
  </template>
}
