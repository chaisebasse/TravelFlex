import { Controller } from "@hotwired/stimulus"

import mapboxgl from "mapbox-gl" // Don't forget this!
import html2canvas from "html2canvas";


export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    coordinates: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mboulland/clid1lg0w001v01r059ib46m5",
      preserveDrawingBuffer: true
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    setTimeout(() => {
      this.#createScreenshot()
    }, 3000);

    this.map.on('load', () => {
      this.map.addSource('route', {
        'type': 'geojson',
        'data': {
          'type': 'Feature',
          'properties': {},
          'geometry': {
            'type': 'LineString',
            'coordinates': this.coordinatesValue
          }
        }
      });

      this.map.addLayer({
        'id': 'route',
        'type': 'line',
        'source': 'route',
        'layout': {
          'line-join': 'round',
          'line-cap': 'round'
          },
        'paint': {
          'line-color': '#0AAFE6',
          'line-width': 6
      }
    });
    });
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 30, maxZoom: 10, duration: 0 })
  }

  #createScreenshot() {
    const mapCanvas = document.querySelector('.mapboxgl-canvas');
    const image_src = mapCanvas.toDataURL();
    // je vais chercher la div du bouton,
/*     je prends sont href, et je modifie la valeur de la query image parent
 */    // mon image_src
  }
};
