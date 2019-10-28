provider "cloudflare" {
  alias = "parent"
  email = "${var.cloudflare_parent_email}"
  api_key = "${var.cloudflare_parent_api_key}"
  account_id = "${var.cloudflare_parent_account_id}"
}

provider "cloudflare" {
  alias = "child"
  email = "${var.cloudflare_child_email}"
  api_key = "${var.cloudflare_child_api_key}"
  account_id = "${var.cloudflare_child_account_id}"
}

resource "cloudflare_worker_script" "parentWorker" {
  provider = "cloudflare.parent"
  name = "parent-worker"
  content = "${file("parentWorker.js")}"
}

resource "cloudflare_worker_route" "parentWorker" {
  provider = "cloudflare.parent"
  zone_id = "${var.cloudflare_parent_zone_id}"
  pattern = "parent.${var.cloudflare_parent_zone}/*"
  script_name = "${cloudflare_worker_script.parentWorker.name}"
  depends_on = ["cloudflare_worker_script.parentWorker"]
}

resource "cloudflare_worker_script" "childWorker" {
  provider = "cloudflare.child"
  name = "child-worker"
  content = "${file("childWorker.js")}"
}

resource "cloudflare_worker_route" "childWorker" {
  provider = "cloudflare.child"
  zone_id = "${var.cloudflare_child_zone_id}"
  pattern = "child.${var.cloudflare_child_zone}/*"
  script_name = "${cloudflare_worker_script.childWorker.name}"
  depends_on = ["cloudflare_worker_script.childWorker"]
}