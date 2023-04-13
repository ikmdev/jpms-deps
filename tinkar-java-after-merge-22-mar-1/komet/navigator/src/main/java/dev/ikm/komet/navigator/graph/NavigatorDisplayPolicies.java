/*
 * Copyright 2017 Organizations participating in ISAAC, ISAAC's KOMET, and SOLOR development include the 
         US Veterans Health Administration, OSHERA, and the Health Services Platform Consortium..
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package dev.ikm.komet.navigator.graph;

import javafx.scene.Node;
import dev.ikm.tinkar.coordinate.view.calculator.ViewCalculator;

/**
 * MultiParentGraphItemDisplayPolicies
 *
 * @author <a href="mailto:joel.kniaz@gmail.com">Joel Kniaz</a>
 */
public interface NavigatorDisplayPolicies {
    /**
     * @param item           the {@link MultiParentVertex} to be evaluated
     * @param viewCalculator
     * @return Node the FX graphical Node generated by the MultiParentGraphItemDisplayPolicies as applied to the specified {@link MultiParentVertex}
     */
    Node computeGraphic(MultiParentVertex item, ViewCalculator viewCalculator);

    /**
     * @param treeItem       the {@link MultiParentVertex}, the visibility of which to evaluate
     * @param viewCalculator
     * @return boolean the boolean value indicating, according to these MultiParentGraphItemDisplayPolicies, whether ({@code true}) or not ({@code false}) the specified {@link MultiParentVertex} should be displayed
     */
    default boolean shouldDisplay(MultiParentVertex treeItem, ViewCalculator viewCalculator) {
        return true;
    }
}
