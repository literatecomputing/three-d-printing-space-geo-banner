import { apiInitializer } from "discourse/lib/api";
import Banner from "../components/banner";

export default apiInitializer("1.14.0", (api) => {
  const currentUser = api.getCurrentUser();
  api.renderInOutlet("topic-above-posts", Banner, { currentUser });
});
