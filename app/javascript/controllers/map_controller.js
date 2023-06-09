import { Controller } from "@hotwired/stimulus"

import mapboxgl from "mapbox-gl" // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Array
  }

  connect() {
    console.log("ici")
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mboulland/clid1lg0w001v01r059ib46m5"
    })

    this.#addMarkerToMap()
    this.#fitMapToMarker()
  }


  #addMarkerToMap() {
    this.markerValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }


    #fitMapToMarker() {

        const bounds = new mapboxgl.LngLatBounds()
        this.markerValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
        this.map.fitBounds(bounds, { padding: 30, maxZoom: 3, duration: 0 })
      }


};
