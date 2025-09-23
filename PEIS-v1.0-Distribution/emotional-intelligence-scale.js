// Pediatric Emotional Intelligence Scale (PEIS) - Scoring Algorithm
// Standard Score: 100 = Age-Appropriate Emotional Intelligence

class PEISScoring {
    constructor() {
        // Age-based normative data for emotional intelligence development
        // Updated with more optimistic but clinically appropriate scoring
        this.ageNorms = {
            2.5: { mean: 50, sd: 8 },
            3.0: { mean: 58, sd: 9 },
            3.5: { mean: 65, sd: 9 },
            4.0: { mean: 71, sd: 10 },
            4.5: { mean: 76, sd: 10 },
            5.0: { mean: 80, sd: 11 },
            5.5: { mean: 84, sd: 11 },
            6.0: { mean: 87, sd: 12 },
            6.5: { mean: 90, sd: 12 },
            7.0: { mean: 92, sd: 12 },
            7.5: { mean: 94, sd: 13 },
            8.0: { mean: 96, sd: 13 },
            8.5: { mean: 98, sd: 13 },
            9.0: { mean: 100, sd: 14 },
            9.5: { mean: 102, sd: 14 },
            10.0: { mean: 104, sd: 14 },
            10.5: { mean: 106, sd: 15 },
            11.0: { mean: 108, sd: 15 },
            11.5: { mean: 110, sd: 15 },
            12.0: { mean: 112, sd: 15 },
            12.5: { mean: 114, sd: 16 },
            13.0: { mean: 116, sd: 16 },
            13.5: { mean: 118, sd: 16 },
            14.0: { mean: 120, sd: 16 },
            14.5: { mean: 122, sd: 17 },
            15.0: { mean: 124, sd: 17 },
            15.5: { mean: 126, sd: 17 },
            16.0: { mean: 128, sd: 17 },
            16.5: { mean: 130, sd: 18 },
            17.0: { mean: 132, sd: 18 },
            17.5: { mean: 134, sd: 18 },
            18.0: { mean: 136, sd: 18 }
        };

        // Domain weights for overall score calculation
        this.domainWeights = {
            selfAwareness: 0.20,
            selfRegulation: 0.25,
            motivation: 0.20,
            empathy: 0.20,
            socialSkills: 0.15
        };
    }

    // Get age norm data with interpolation for ages between defined points
    getAgeNorm(age) {
        // Round to nearest 0.5
        const roundedAge = Math.round(age * 2) / 2;
        
        if (this.ageNorms[roundedAge]) {
            return this.ageNorms[roundedAge];
        }
        
        // Interpolate between closest ages
        const lowerAge = Math.floor(age * 2) / 2;
        const upperAge = Math.ceil(age * 2) / 2;
        
        if (this.ageNorms[lowerAge] && this.ageNorms[upperAge]) {
            const factor = (age - lowerAge) / (upperAge - lowerAge);
            return {
                mean: this.ageNorms[lowerAge].mean + factor * (this.ageNorms[upperAge].mean - this.ageNorms[lowerAge].mean),
                sd: this.ageNorms[lowerAge].sd + factor * (this.ageNorms[upperAge].sd - this.ageNorms[lowerAge].sd)
            };
        }
        
        // Default for out-of-range ages
        return age < 2.5 ? this.ageNorms[2.5] : this.ageNorms[18.0];
    }

    // Calculate raw scores for each domain
    calculateDomainScores(responses) {
        const domains = {
            selfAwareness: [1, 2, 3, 4, 5, 6],
            selfRegulation: [7, 8, 9, 10, 11, 12],
            motivation: [13, 14, 15, 16, 17, 18],
            empathy: [19, 20, 21, 22, 23, 24],
            socialSkills: [25, 26, 27, 28, 29, 30]
        };

        const domainScores = {};
        
        for (const [domain, questions] of Object.entries(domains)) {
            let total = 0;
            let validResponses = 0;
            
            questions.forEach(q => {
                if (responses[`q${q}`] !== undefined) {
                    total += parseInt(responses[`q${q}`]);
                    validResponses++;
                }
            });
            
            // Calculate percentage score for domain (0-100)
            const maxPossible = validResponses * 4; // 4 is max rating
            domainScores[domain] = validResponses > 0 ? (total / maxPossible) * 100 : 0;
        }
        
        return domainScores;
    }

    // Calculate overall raw score
    calculateRawScore(responses) {
        let totalScore = 0;
        let validResponses = 0;
        
        for (let i = 1; i <= 30; i++) {
            if (responses[`q${i}`] !== undefined) {
                totalScore += parseInt(responses[`q${i}`]);
                validResponses++;
            }
        }
        
        // Convert to percentage (0-100)
        const maxPossible = validResponses * 4;
        return validResponses > 0 ? (totalScore / maxPossible) * 100 : 0;
    }

    // Convert raw score to standard score (mean=100, sd=15)
    calculateStandardScore(rawScore, age) {
        const ageNorm = this.getAgeNorm(age);
        
        // Convert raw percentage to z-score
        const zScore = (rawScore - ageNorm.mean) / ageNorm.sd;
        
        // Convert z-score to standard score (mean=100, sd=15)
        const standardScore = Math.round(100 + (zScore * 15));
        
        // Ensure score is within reasonable bounds
        return Math.max(40, Math.min(160, standardScore));
    }

    // Calculate emotional age equivalent
    calculateEmotionalAge(rawScore) {
        let closestAge = 2.5;
        let smallestDifference = Math.abs(rawScore - this.ageNorms[2.5].mean);
        
        for (const [age, norm] of Object.entries(this.ageNorms)) {
            const difference = Math.abs(rawScore - norm.mean);
            if (difference < smallestDifference) {
                smallestDifference = difference;
                closestAge = parseFloat(age);
            }
        }
        
        return closestAge;
    }

    // Get interpretation based on standard score
    getInterpretation(standardScore, chronologicalAge, emotionalAge) {
        let level, description, ageDifference;
        
        ageDifference = emotionalAge - chronologicalAge;
        
        if (standardScore >= 130) {
            level = "Very Superior";
            description = "Exceptional emotional intelligence skills";
        } else if (standardScore >= 120) {
            level = "Superior";
            description = "Above average emotional intelligence skills";
        } else if (standardScore >= 110) {
            level = "High Average";
            description = "Good emotional intelligence skills";
        } else if (standardScore >= 90) {
            level = "Average";
            description = "Age-appropriate emotional intelligence skills";
        } else if (standardScore >= 80) {
            level = "Low Average";
            description = "Slightly below average emotional intelligence skills";
        } else if (standardScore >= 70) {
            level = "Borderline";
            description = "Below average emotional intelligence skills";
        } else {
            level = "Significantly Below Average";
            description = "Significantly delayed emotional intelligence skills";
        }
        
        return { level, description, ageDifference };
    }

    // Generate recommendations based on domain scores
    generateRecommendations(domainScores, interpretation) {
        const recommendations = [];
        
        // Domain-specific recommendations
        if (domainScores.selfAwareness < 70) {
            recommendations.push("Practice emotion identification activities and feeling vocabulary");
            recommendations.push("Use emotion charts and mirrors for self-reflection exercises");
        }
        
        if (domainScores.selfRegulation < 70) {
            recommendations.push("Teach calming strategies like deep breathing and counting");
            recommendations.push("Practice impulse control games and delayed gratification activities");
        }
        
        if (domainScores.motivation < 70) {
            recommendations.push("Set achievable goals and celebrate small successes");
            recommendations.push("Encourage persistence through challenging but manageable tasks");
        }
        
        if (domainScores.empathy < 70) {
            recommendations.push("Read books about emotions and discuss characters' feelings");
            recommendations.push("Practice perspective-taking through role-playing activities");
        }
        
        if (domainScores.socialSkills < 70) {
            recommendations.push("Facilitate structured social interactions and group activities");
            recommendations.push("Teach conflict resolution and communication skills");
        }
        
        // General recommendations based on overall performance
        if (interpretation.level === "Very Superior" || interpretation.level === "Superior") {
            recommendations.push("Consider leadership opportunities and peer mentoring roles");
            recommendations.push("Provide advanced emotional intelligence challenges");
        } else if (interpretation.level === "Borderline" || interpretation.level === "Significantly Below Average") {
            recommendations.push("Consider professional evaluation for emotional or behavioral concerns");
            recommendations.push("Implement structured emotional intelligence intervention program");
        }
        
        return recommendations;
    }
}

// Initialize scoring system
const peisScoring = new PEISScoring();

// Event listener for score calculation
document.addEventListener('DOMContentLoaded', function() {
    const calculateButton = document.getElementById('calculateScore');
    const resultsSection = document.getElementById('results');
    
    calculateButton.addEventListener('click', function() {
        // Validate form completion
        const form = document.getElementById('assessmentForm');
        const childInfo = document.getElementById('childInfo');
        
        if (!childInfo.checkValidity()) {
            alert('Please complete all child information fields.');
            return;
        }
        
        if (!form.checkValidity()) {
            alert('Please answer all assessment questions.');
            return;
        }
        
        // Collect responses
        const responses = {};
        for (let i = 1; i <= 30; i++) {
            const radioButtons = document.getElementsByName(`q${i}`);
            for (const radio of radioButtons) {
                if (radio.checked) {
                    responses[`q${i}`] = radio.value;
                    break;
                }
            }
        }
        
        // Get child information
        const childAge = parseFloat(document.getElementById('childAge').value);
        const childName = document.getElementById('childName').value;
        
        // Calculate scores
        const domainScores = peisScoring.calculateDomainScores(responses);
        const rawScore = peisScoring.calculateRawScore(responses);
        const standardScore = peisScoring.calculateStandardScore(rawScore, childAge);
        const emotionalAge = peisScoring.calculateEmotionalAge(rawScore);
        const interpretation = peisScoring.getInterpretation(standardScore, childAge, emotionalAge);
        const recommendations = peisScoring.generateRecommendations(domainScores, interpretation);
        
        // Display results
        displayResults(childName, childAge, standardScore, emotionalAge, interpretation, domainScores, recommendations);
        
        // Show results section
        resultsSection.style.display = 'block';
        resultsSection.scrollIntoView({ behavior: 'smooth' });
    });
});

function displayResults(childName, childAge, standardScore, emotionalAge, interpretation, domainScores, recommendations) {
    // Score display
    document.getElementById('scoreDisplay').innerHTML = `
        <div class="score-display">
            <div class="total-score">${standardScore}</div>
            <div class="score-interpretation">${interpretation.level}</div>
            <div class="emotional-age">Emotional Age: ${emotionalAge} years</div>
            <p style="margin-top: 10px; color: #7f8c8d;">
                ${childName} (Age ${childAge}) scored ${standardScore} on the PEIS
            </p>
        </div>
    `;
    
    // Domain scores
    const domainNames = {
        selfAwareness: 'Self-Awareness',
        selfRegulation: 'Self-Regulation',
        motivation: 'Motivation',
        empathy: 'Empathy',
        socialSkills: 'Social Skills'
    };
    
    let domainHTML = '<div class="domain-scores">';
    for (const [domain, score] of Object.entries(domainScores)) {
        domainHTML += `
            <div class="domain-score">
                <div class="domain-name">${domainNames[domain]}</div>
                <div class="domain-value">${Math.round(score)}%</div>
            </div>
        `;
    }
    domainHTML += '</div>';
    document.getElementById('domainScores').innerHTML = domainHTML;
    
    // Interpretation
    document.getElementById('interpretation').innerHTML = `
        <div class="interpretation-section">
            <h3>Interpretation</h3>
            <p><strong>Overall Level:</strong> ${interpretation.level}</p>
            <p><strong>Description:</strong> ${interpretation.description}</p>
            <p><strong>Age Comparison:</strong> ${childName}'s emotional intelligence is ${
                interpretation.ageDifference > 0 ? 
                `${Math.abs(interpretation.ageDifference).toFixed(1)} years ahead of` :
                interpretation.ageDifference < 0 ?
                `${Math.abs(interpretation.ageDifference).toFixed(1)} years behind` :
                'equivalent to'
            } their chronological age.</p>
        </div>
    `;
    
    // Recommendations
    let recommendationsHTML = `
        <div class="recommendations-section">
            <h3>Recommendations</h3>
            <ul>
    `;
    recommendations.forEach(rec => {
        recommendationsHTML += `<li>${rec}</li>`;
    });
    recommendationsHTML += '</ul></div>';
    document.getElementById('recommendations').innerHTML = recommendationsHTML;
}